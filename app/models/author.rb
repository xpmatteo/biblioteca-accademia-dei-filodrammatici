class Author < ActiveRecord::Base
  has_many :documents
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
end
