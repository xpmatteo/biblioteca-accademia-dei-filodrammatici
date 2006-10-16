class CreateAuthorships < ActiveRecord::Migration
  def self.up
    create_table :authorships do |t|
      t.column :document_id, :integer
      t.column :author_id, :integer
      t.column :type, :string
    end
  end

  def self.down
    drop_table :authorships
  end
end
