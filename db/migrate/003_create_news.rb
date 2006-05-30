class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      # t.column :name, :string
      t.column :title, :string
      t.column :body, :text
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :news
  end
end
