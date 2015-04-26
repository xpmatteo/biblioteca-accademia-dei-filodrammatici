class AddTranslatorToDocumentVersions < ActiveRecord::Migration
  def self.up
    add_column :document_versions, :translator, :string
  end

  def self.down
    remove_column :document_versions, :translator
  end
end