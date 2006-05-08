class AddShowInNavigation < ActiveRecord::Migration
  def self.up
    add_column :contents, :show_in_navigation, :boolean, :default => false
  end

  def self.down
    remove_column :contents, :show_in_navigation
  end
end
