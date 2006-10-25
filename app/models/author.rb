class Author < ActiveRecord::Base
  validates_uniqueness_of :id_sbn
  validates_presence_of :name, :id_sbn

  def self.initials
    sql = 'select distinct upper(left(name, 1)) as initial 
           from authors
           where name is not null
           order by initial'
    self.find_by_sql(sql).map do |g|
      g.initial
    end
  end
  
  def documents
    Document.find(
      :all, 
      :conditions => ["documents.id in (select document_id from marc_fields where tag like '7%' and subfield_3 = ?)", id_sbn]
      )
  end
end
