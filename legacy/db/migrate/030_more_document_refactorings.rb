class MoreDocumentRefactorings < ActiveRecord::Migration
  def self.up
    remove_column :documents, :accademia_inventory
  end

  def self.down
    add_column :documents, :accademia_inventory, :string
  end
end
