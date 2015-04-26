class AddDocumentVersionsTable < ActiveRecord::Migration
  def self.up
    self.down
    Document.create_versioned_table
    
    page = 100
    (0..130).each do |offset|
      Document.find(:all, :limit => page, :offset => offset*page).each do |d|
        d.save
      end
      puts page*(offset+1)
    end
  end

  def self.down
    Document.drop_versioned_table
  rescue
  end
end
