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
  
  def self.consolidate!
    count = 0
    authors_with_duplicates.each do |awd|
      duplicates_of(awd).each do |dupe|
        transfer_responsibilities_from_to(dupe, awd)
        dupe.destroy
        puts "consolidating: #{count += 1} authors done" if count % 10 == 0
      end
    end
  end

  def self.authors_with_duplicates
    sql = <<-SQL
      select * from authors where id in 
        (select min(id) from authors group by name having count(*) > 1)
    SQL
    Author.find_by_sql(sql)
  end
  
  def self.duplicates_of(author_with_duplicates)
    Author.find(:all, :conditions => ["name = ? and id_sbn <> ?", 
        author_with_duplicates.name, author_with_duplicates.id_sbn])
  end

  def self.transfer_responsibilities_from_to(from, to)
    from.responsibilities.each do |resp|
      doc = Document.find(resp.document_id)
      begin
        if doc.author == from
          doc.author = to 
          doc.save!
        else
          resp.update_attribute(:author_id, to.id)
        end        
      rescue         
        puts $!
      end      
    end
  end
end

