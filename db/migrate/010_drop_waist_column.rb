class DropWaistColumn < ActiveRecord::Migration
  def self.up
    remove_column :graduates, :waist
  end

  def self.down
    add_column :graduates, :waist, :string
  end
end
