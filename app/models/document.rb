class Document < ActiveRecord::Base
  validates_uniqueness_of :id_sbn
  validates_presence_of :id_sbn, :title

  acts_as_tree :order => 'id_sbn'
  
  has_many :responsibilities
  has_many :names, :source => :author, :through => :responsibilities, :order => :name
  belongs_to :author
  
  def collection
    return nil unless collection_name
    return collection_name unless collection_volume
    collection_name + " ; " + collection_volume
  end
  
  def Document.find_by_keywords(keywords)
    sql = "select * 
             from documents
            where match (title, publication, notes, responsibilities_denormalized, national_bibliography_number, id_sbn) 
                against (:keywords)"
    Document.find_by_sql([sql, {:keywords => keywords}])
  end
  
end
