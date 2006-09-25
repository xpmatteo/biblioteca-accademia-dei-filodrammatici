class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table :menu_items do |t|
      t.column :parent_id, :integer
      t.column :title, :string
      t.column :controller, :string
      t.column :item_id, :integer
      t.column :position, :integer
    end
  end

  def self.down
    drop_table :menu_items
  end
end
