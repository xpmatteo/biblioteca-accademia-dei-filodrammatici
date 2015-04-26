class IndexAuthors < ActiveRecord::Migration
  def self.up
    add_index :marc_fields, :subfield_3
    add_index :marc_fields, :document_id
  end

  def self.down
    remove_index :marc_fields, :subfield_3
    remove_index :marc_fields, :document_id
  end
end
