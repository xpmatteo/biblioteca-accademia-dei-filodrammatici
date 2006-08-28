class AddColumnImageToGraduates < ActiveRecord::Migration
  def self.up
    add_column :graduates, :image, :string
  end

  def self.down
    remove_column :graduates, :image
  end
end
