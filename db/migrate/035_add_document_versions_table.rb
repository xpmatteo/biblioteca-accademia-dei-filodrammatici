class AddDocumentVersionsTable < ActiveRecord::Migration
  def self.up
    Document.create_versioned_table
    Document.find(:all).each do |d|
      @count ||= 0
      @count += 1
      puts @count if @count % 100 == 0
      d.save
    end
  end

  def self.down
    Document.drop_versioned_table
  end
end
