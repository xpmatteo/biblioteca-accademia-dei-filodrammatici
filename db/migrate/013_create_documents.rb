class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.column :sbn_record_id, :string
      t.column :insertion, :datetime
      t.column :version, :datetime
      t.column :language, :string
      t.column :title,                  :string
      t.column :fingerprint,            :string
      t.column :country_of_publication, :string
    end
  end

  def self.down
    drop_table :documents
  end
end
