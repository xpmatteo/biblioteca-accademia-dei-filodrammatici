class DeleteObsoleteTables < ActiveRecord::Migration
  def self.up
    drop_table :news
    drop_table :graduates
    drop_table :menu_items
    drop_table :teachers
  end

  def self.down
  end
end
