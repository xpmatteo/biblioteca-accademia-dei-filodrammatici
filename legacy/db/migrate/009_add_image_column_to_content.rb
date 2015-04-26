class AddImageColumnToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :image, :string
    remove_column :contents, :image_url
  end

  def self.down
    remove_column :contents, :image
    add_column :contents, :image_url, :string
  end
end
