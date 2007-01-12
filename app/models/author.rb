class Author < ActiveRecord::Base
  validates_uniqueness_of :id_sbn
  validates_presence_of :name, :id_sbn

  has_many :responsibilities
  has_many :documents, :through => :responsibilities, :order => :title

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
