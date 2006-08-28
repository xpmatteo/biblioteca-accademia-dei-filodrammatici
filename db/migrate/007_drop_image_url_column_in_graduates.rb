class DropImageUrlColumnInGraduates < ActiveRecord::Migration
  def self.up
    remove_column :graduates, :image_url
  end

  def self.down
    add_column :graduates, :image_url, :string
  end
end
