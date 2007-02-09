class CreatePublishersEmblems < ActiveRecord::Migration
  def self.up
    create_table :publishers_emblems do |t|
      t.column :description, :string
      t.column :id_sbn, :string
      t.column :code, :string
    end
    add_column :documents, :publishers_emblem_id, :integer
  end

  def self.down
    drop_table :publishers_emblems
    remove_column :documents, :publishers_emblem_id
  end
end
