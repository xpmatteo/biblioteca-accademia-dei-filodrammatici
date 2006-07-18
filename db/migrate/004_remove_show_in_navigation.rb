class RemoveShowInNavigation < ActiveRecord::Migration
  def self.up
    remove_column :contents, :show_in_navigation
    remove_column :contents, :sort_value
  end
  
  def self.down
    add_column :contents, :show_in_navigation, :boolean, :default => false
    add_column :contents, :sort_value,         :string
  end
end
