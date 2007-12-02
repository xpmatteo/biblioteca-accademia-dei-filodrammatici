class Document < ActiveRecord::Base
  MAX_DOCUMENTS_TO_RETURN = 100
  
  validates_uniqueness_of :id_sbn, :if => Proc.new {|doc| !doc.id_sbn.blank?}
  validates_presence_of :title
  validates_numericality_of :value,   :allow_nil => true
  validates_numericality_of :century, :allow_nil => true, :only_integer => true
  validates_numericality_of :year,    :allow_nil => true, :only_integer => true
  validates_inclusion_of :document_type,  :in => %w(serial monograph set)
  validates_inclusion_of :hierarchy_type, :in => %w(serial composition issued_with), :allow_nil => true

  acts_as_ferret :fields => %w(title  publication  notes  responsibilities_denormalized  national_bibliography_number  id_sbn)

  # l'idea è che se i titoli iniziano con un numero, è meglio ordinare numericamente
  # e se contengono un asterisco, vanno ordinati a partire dall'asterisco
  CANONICAL_ORDER = "cast(title as unsigned), right(title, length(title) - locate('*', title))"
  acts_as_tree :order => CANONICAL_ORDER
  
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
    Document.find_by_contents(keywords, :limit => MAX_DOCUMENTS_TO_RETURN)
  end
  
  def Document.prune_children(list)
    list.reject {|elem| list.member?(elem.parent)}
  end
  
  def title_without_asterisk
    title.gsub("*", "")
  end

  def self.filter_stopwords(query)
    stopwords = %w( di in commedia la e del il un atti. tre de dramma da atti le traduzione en a due signor
    tragedia i teatro atto versione dal per della cinque italiana sig et cura con actes quattro l' comedie
    una inedita 3 tomo )

    stopwords.each do |stop|
      rx = Regexp.new("\\b#{stop}\\b", Regexp::IGNORECASE)
      query.gsub!(rx, '')
    end
    query.strip
  end
private
  
  def add_author_to_names
    if author_id && ! names.member?(author)
      Responsibility.create!(:document_id => id, :author_id => author.id, :unimarc_tag => "700")
    end
  end
end
