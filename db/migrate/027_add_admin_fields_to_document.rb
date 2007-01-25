class AddAdminFieldsToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :admin_notes, :text
    add_column :documents, :accademia_inventory, :string
    add_column :documents, :value, :decimal, :precision => 15, :scale => 2
    add_column :documents, :year, :integer
    add_column :documents, :place, :string
    add_column :documents, :publisher, :string
    add_column :documents, :century, :integer
    add_column :documents, :hierarchy_type, :string
  end

  def self.down
    remove_column :documents, :admin_notes
    remove_column :documents, :accademia_inventory
    remove_column :documents, :value
    remove_column :documents, :year
    remove_column :documents, :place
    remove_column :documents, :publisher
    remove_column :documents, :century
    remove_column :documents, :hierarchy_type
  end
end