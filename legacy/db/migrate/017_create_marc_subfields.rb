class CreateMarcSubfields < ActiveRecord::Migration
  def self.up
    create_table :marc_subfields do |t|
      t.column :code, :string, :limit => 1
      t.column :marc_field_id, :integer
      t.column :body, :string
    end
  end

  def self.down
    drop_table :marc_subfields
  end
end
