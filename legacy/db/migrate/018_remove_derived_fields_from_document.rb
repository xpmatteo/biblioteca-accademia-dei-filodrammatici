class RemoveDerivedFieldsFromDocument < ActiveRecord::Migration
  def self.up
    remove_column :documents, :title
    remove_column :documents, :place_of_publication
    remove_column :documents, :publisher
    remove_column :documents, :date_of_publication    
    remove_column :documents,  "author_id"
    remove_column :documents,  "insertion"
    remove_column :documents,  "version"
    remove_column :documents,  "language"
    remove_column :documents,  "title_without_article"
    remove_column :documents,  "subtitles"
    remove_column :documents,  "sub_responsibility"
    remove_column :documents,  "fingerprint"
    remove_column :documents,  "country_of_publication"
  end

  def self.down
    add_column :documents, :title, :string
    add_column :documents, :place_of_publication, :string
    add_column :documents, :publisher, :string
    add_column :documents, :date_of_publication, :date
    add_column :documents,  "author_id", :integer
    add_column :documents,  "insertion", :datetime
    add_column :documents,  "version", :datetime
    add_column :documents,  "language", :string
    add_column :documents,  "title_without_article", :string
    add_column :documents,  "subtitles", :string
    add_column :documents,  "sub_responsibility", :string
    add_column :documents,  "fingerprint", :string
    add_column :documents,  "country_of_publication", :string
  rescue
  end
end
