class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.column :author_id,              :integer
      t.column :id_sbn,                 :string
      t.column :insertion,              :datetime
      t.column :version,                :datetime
      t.column :language,               :string
      t.column :title,                  :string
      t.column :title_without_article,  :string
      t.column :subtitles,              :string
      t.column :sub_responsibility,     :string
      t.column :fingerprint,            :string
      t.column :country_of_publication, :string
      t.column :place_of_publication,   :string
      t.column :date_of_publication,    :string
      t.column :publisher,              :string
    end
  end

  def self.down
    drop_table :documents
  end
end
