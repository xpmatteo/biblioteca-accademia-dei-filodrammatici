class CreateMarcFields < ActiveRecord::Migration
  def self.up
    create_table :marc_fields do |t|
      t.column :tag, :string, :limit => 3
      t.column :document_id, :integer
    end
  end

  def self.down
    drop_table :marc_fields
  end
end
