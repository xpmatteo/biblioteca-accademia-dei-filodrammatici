class Document < ActiveRecord::Base
  MAX_DOCUMENTS_TO_RETURN = 100000
  PAGE_SIZE = 10

  DOCUMENT_TYPES = [
    ["Monografia", "monograph"],
    ["Periodico", "serial"],
    ["Spoglio di periodico", "in-serial"],
    ["Tesi di Laurea", "thesis"],
    ["Manoscritto", "manuscript"],
  ]

  DOCUMENT_TYPES_FOR_MANUSCRIPT = [
    ["Manoscritto", "manuscript"],
    ["Tesi di Laurea", "thesis"],
  ]

  validates_uniqueness_of :id_sbn, :if => Proc.new {|doc| !doc.id_sbn.blank?}
  validates_presence_of :title
  validates_numericality_of :value,   :allow_nil => true
  validates_numericality_of :century, :allow_nil => true, :only_integer => true
  validates_numericality_of :year,    :allow_nil => true, :only_integer => true
  validates_inclusion_of :document_type,  :in => %w(serial monograph set in-serial manuscript thesis)
  validates_inclusion_of :hierarchy_type, :in => %w(serial composition issued_with), :allow_nil => true

  THE_PART_OF_TITLE_BEFORE_THE_ASTERISK = "trim(right(title, length(title) - locate('*', title)))"

  # l'idea è che se i titoli iniziano con un numero, è meglio ordinare numericamente
  # e se contengono un asterisco, vanno ordinati a partire dall'asterisco
  CANONICAL_ORDER = "cast(title as unsigned), #{THE_PART_OF_TITLE_BEFORE_THE_ASTERISK}"

  # acts_as_versioned

  has_many :responsibilities
  has_many :names, :source => :author, :through => :responsibilities, :order => :name
  belongs_to :author
  belongs_to :publishers_emblem

  after_save :add_author_to_names
  before_save :compute_century

  def self.title_initials
     sql = "select distinct upper(left(#{THE_PART_OF_TITLE_BEFORE_THE_ASTERISK}, 1)) as initial
            from documents
            order by initial"
     self.find_by_sql(sql).map do |g|
       g.initial
     end
  end

  def parent
    Document.find_by_id(self.parent_id)
  end

  def children
    Document.find_all_by_parent_id(self.id, :order => CANONICAL_ORDER)
  end

  def edited_with_manuscript_form
    %w(manuscript thesis).include? self.document_type
  end

  def collection
    return nil if collection_name.blank?
    return collection_name unless collection_volume
    collection_name + "; " + collection_volume
  end

  def self.paginate(options)
    options = options.dup
    options[:per_page] ||= PAGE_SIZE
    options[:page] || raise("missing page parameter")
    sql = sql_for_find(options)
    return nil unless sql
    results = Document.paginate_by_sql([sql, options], options)
    results.each_with_index { |doc, index| doc["result_index"] = index + offset(options) }
  end

  def title_without_asterisk
    title.gsub("*", "")
  end

  def Document.prepare_keywords_for_boolean_mode_query(keywords)
    keywords.split(" ").map {|word| "+#{word}"}.join(" ")
  end

  # proteggi le versioni salvate; non verranno cancellate quando
  # il documento viene cancellato (thanks http://ward.vandewege.net/blog/2007/02/27/116/)
  # self.versioned_class.class_eval do
  #   def self.delete_all(conditions = nil); return; end
  # end

private

  def add_author_to_names
    if author_id && !Responsibility.find_by_author_id_and_document_id(author.id, id)
      Responsibility.create!(:document_id => id, :author_id => author.id, :unimarc_tag => "700")
    end
  end

  def compute_century
    if self.century.blank? and not self.year.blank?
      self.century = self.year / 100 + 1
    end
  end

  def self.sql_for_find(options)
    conditions = []
    conditions << "year >= :year_from" unless options[:year_from].blank?
    conditions << "year <= :year_to"   unless options[:year_to].blank?
    conditions << "document_type = :document_type"   unless options[:document_type].blank?

    unless options[:author_id].blank?
      by_author = "(author_id is not null and author_id = :author_id)"
      by_responsibility = "id in (select document_id from responsibilities where author_id = :author_id)"
      conditions << "(#{by_author} or #{by_responsibility})"
    end

    unless options[:century].blank?
      options[:century] = RomanNumerals.roman_to_decimal(options[:century])
      conditions << "(century = :century or year div 100 + 1 = :century)"
    end

    unless options[:publishers_emblem_id].blank?
      conditions << "publishers_emblem_id = :publishers_emblem_id"
    end

    unless options[:year].blank?
      conditions << "year = :year"
    end

    unless options[:collection_name].blank?
      conditions << "collection_name = :collection_name"
    end

    unless options[:title_initial].blank?
      options[:title_initial] = options[:title_initial] + '%'
      conditions << "#{THE_PART_OF_TITLE_BEFORE_THE_ASTERISK} like :title_initial"
    end

    unless options[:keywords].blank?
      options[:keywords] = Document.prepare_keywords_for_boolean_mode_query(options[:keywords])
      conditions <<
        "match (title, publication, notes, responsibilities_denormalized, national_bibliography_number, id_sbn)
         against (:keywords in boolean mode)"
    end

    options[:order] ||= ""
    if options[:order] == "year"
      order = "coalesce(year, (century-1) * 100, 9999)"
      tables = "documents D"
    elsif options[:order] == "author"
      order = "A.name"
      tables = "documents D left join authors A on (D.author_id = A.id)"
    else
      order = CANONICAL_ORDER
      tables = "documents D"
    end

    return nil if conditions.empty?
    where = conditions.join(" and ")

    # il discorso di parent_id serve ad evitare di restituire documenti il cui
    # padre viene già restituito dalla stessa query
    "select D.*
             from #{tables}
            where #{where}
              and (parent_id is null or parent_id not in (select id from documents where #{where}))
         order by #{order}"
  end

  def self.offset(options)
    if options[:page]
      PAGE_SIZE * (options[:page].to_i - 1)
    else
      0
    end
  end
end
