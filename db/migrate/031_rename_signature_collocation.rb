class RenameSignatureCollocation < ActiveRecord::Migration
  def self.up
    rename_column :documents, :signature, :collocation
  end

  def self.down
    rename_column :documents, :collocation, :signature
  end
end
