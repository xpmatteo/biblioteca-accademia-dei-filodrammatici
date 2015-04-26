class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.column :title,      :string
      t.column :name,       :string
      t.column :body,       :text
      t.column :image_url,  :string
      t.column :sort_value, :string
    end
  end

  def self.down
    drop_table :contents
  end
end
