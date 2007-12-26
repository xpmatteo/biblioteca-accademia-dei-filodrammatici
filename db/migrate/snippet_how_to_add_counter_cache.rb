class AddChildrenCount < ActiveRecord::Migration
  def self.up
    add_column :documents, :children_count, :integer, :default => 0
    
    Document.reset_column_information
    Document.find(:all).each do |d|
      d.update_attribute :children_count, d.children.length
    end
  end

  def self.down
    remove_column :documents, :children_count
  end
end
