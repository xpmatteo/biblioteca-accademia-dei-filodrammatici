class AddTranslatorToDocument < ActiveRecord::Migration
  def self.up
    add_column :documents, :translator, :string
  end

  def self.down
    remove_column :documents, :translator
  end
end