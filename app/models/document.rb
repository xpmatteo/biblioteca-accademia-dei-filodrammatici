class Document < ActiveRecord::Base
  MAX_DOCUMENTS_TO_RETURN = 100

  DOCUMENT_TYPES = [
    ["Monografia", "monograph"],
    ["Periodico", "serial"],
    ["Spoglio di periodico", "in-serial"],
    ]

  validates_uniqueness_of :id_sbn, :if => Proc.new {|doc| !doc.id_sbn.blank?}
  validates_presence_of :title
  validates_numericality_of :value,   :allow_nil => true
  validates_numericality_of :century, :allow_nil => true, :only_integer => true
  validates_numericality_of :year,    :allow_nil => true, :only_integer => true
  validates_inclusion_of :document_type,  :in => %w(serial monograph set in-serial)
  validates_inclusion_of :hierarchy_type, :in => %w(serial composition issued_with), :allow_nil => true

  # l'idea è che se i titoli iniziano con un numero, è meglio ordinare numericamente
  # e se contengono un asterisco, vanno ordinati a partire dall'asterisco
  CANONICAL_ORDER = "cast(title as unsigned), right(title, length(title) - locate('*', title))"
  acts_as_tree :order => CANONICAL_ORDER
  
  acts_as_versioned
  
  has_many :responsibilities
  has_many :names, :source => :author, :through => :responsibilities, :order => :name
  belongs_to :author
  belongs_to :publishers_emblem
  
  after_save :add_author_to_names
  
  def collection
    return nil if collection_name.blank?
    return collection_name unless collection_volume
    collection_name + "; " + collection_volume
  end
  
  def Document.find_by_keywords(keywords)
    Document.find_all_by_options(:keywords => keywords)
  end
  
  def Document.prune_children(list)
    list.reject {|elem| list.member?(elem.parent)}
  end

  def Document.find_all_by_options(options)
    options = options.dup

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
      conditions << "century = :century" 
    end
    
    unless options[:keywords].blank?
      options[:keywords] = Document.prepare_keywords_for_boolean_mode_query(options[:keywords])
      conditions << 
        "match (title, publication, notes, responsibilities_denormalized, national_bibliography_number, id_sbn) 
         against (:keywords in boolean mode)"
    end

    return nil if conditions.empty?
    where = conditions.join(" and ")
    
    # il discorso di parent_id serve ad evitare di restituire documenti il cui
    # padre viene giò restituito dalla stessa query
    sql = "select * from documents 
            where #{where}
              and (parent_id is null or parent_id not in (select id from documents where #{where}))
         order by #{CANONICAL_ORDER} 
            limit #{MAX_DOCUMENTS_TO_RETURN}"
    Document.find_by_sql([sql, options])      
  end

  def title_without_asterisk
    title.gsub("*", "")
  end

  def Document.prepare_keywords_for_boolean_mode_query(keywords)
    keywords.split(" ").map {|word| "+#{word}"}.join(" ")
  end

  # proteggi le versioni salvate; non verranno cancellate quando
  # il documento viene cancellato (thanks http://ward.vandewege.net/blog/2007/02/27/116/)
  self.versioned_class.class_eval do
    def self.delete_all(conditions = nil); return; end
  end
  
private

  def add_author_to_names
    if author_id && ! names.member?(author)
      Responsibility.create!(:document_id => id, :author_id => author.id, :unimarc_tag => "700")
    end
  end
end
