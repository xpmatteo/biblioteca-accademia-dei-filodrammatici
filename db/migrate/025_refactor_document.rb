class RefactorDocument < ActiveRecord::Migration
  OPTIONS = { :force => true, :options => "collate 'utf8_unicode_ci', type 'MyISAM'" }
  def self.up
    create_table "authors", OPTIONS do |t|
      t.column "name",   :string
      t.column "id_sbn", :string
    end

    create_table "documents", OPTIONS do |t|
      t.column "parent_id",                    :integer
      t.column "author_id",                    :integer
      t.column "id_sbn",                       :string
      t.column "title",                        :string
      t.column "publication",                  :string
      t.column "notes",                        :string
      t.column "signature",                    :string
      t.column "footprint",                    :string
      t.column "physical_description",         :string
      t.column "national_bibliography_number", :string
      t.column "collection_name",              :string
      t.column "collection_volume",            :string
      t.column "responsibilities_denormalized", :string
    end

    execute <<-END      
      CREATE FULLTEXT INDEX fulltext_documents 
          ON documents (title, publication, notes, responsibilities_denormalized, national_bibliography_number, id_sbn)
    END

    create_table :responsibilities, OPTIONS do |t|
      t.column :author_id,    :integer
      t.column :document_id,  :integer
      t.column :unimarc_tag,  :string
    end    

    begin
      drop_table "marc_fields"
    rescue
    end    
  end

  def self.down
  end
end
