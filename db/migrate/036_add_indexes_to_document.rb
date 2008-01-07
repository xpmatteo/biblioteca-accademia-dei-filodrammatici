class AddIndexesToDocument < ActiveRecord::Migration
  def self.up
    add_index :documents, :year
    add_index :documents, :century
    add_index :documents, :document_type
  end

  def self.down
    remove_index :documents, :year
    remove_index :documents, :century
    remove_index :documents, :document_type
  end
end
