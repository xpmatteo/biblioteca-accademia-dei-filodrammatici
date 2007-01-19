class AddAutomaticFields < ActiveRecord::Migration
  class Document < ActiveRecord::Base; end
  
  def self.up
    add_column :documents, :updated_at, :datetime
    add_column :documents, :created_at, :datetime
    execute "update documents set created_at = now()"
  end

  def self.down
    remove_column :documents, :updated_at
    remove_column :documents, :created_at
  end
end
