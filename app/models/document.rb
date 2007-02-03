class Document < ActiveRecord::Base
  validates_uniqueness_of :id_sbn
  validates_presence_of :id_sbn, :title
  validates_numericality_of :value,   :allow_nil => true
  validates_numericality_of :century, :allow_nil => true, :only_integer => true
  validates_numericality_of :year,    :allow_nil => true, :only_integer => true
  validates_inclusion_of :document_type,  :in => %w(serial monograph set)
  validates_inclusion_of :hierarchy_type, :in => %w(serial composition issued_with), :allow_nil => true

  # l'idea è che se i titoli iniziano con un numero, è meglio ordinare numericamente
  # e se contengono un asterisco, vanno ordinati a partire dall'asterisco
  acts_as_tree :order => "cast(title as unsigned), right(title, length(title) - locate('*', title))"
  
  has_many :responsibilities
  has_many :names, :source => :author, :through => :responsibilities, :order => :name
  belongs_to :author
  
  after_save :add_author_to_names
  
  def collection
    return nil if collection_name.blank?
    return collection_name unless collection_volume
    collection_name + "; " + collection_volume
  end
  
  def Document.find_by_keywords(keywords)
    sql = "select * 
             from documents
            where match (title, publication, notes, responsibilities_denormalized, national_bibliography_number, id_sbn) 
                against (:keywords)"
    Document.find_by_sql([sql, {:keywords => keywords}])
  end
  
  def Document.prune_children(list)
    list.reject {|elem| list.member?(elem.parent)}
  end
  
private
  
  def add_author_to_names
    if author_id && ! names.member?(author)
      Responsibility.create!(:document_id => id, :author_id => author.id, :unimarc_tag => "700")
    end
  end
end
