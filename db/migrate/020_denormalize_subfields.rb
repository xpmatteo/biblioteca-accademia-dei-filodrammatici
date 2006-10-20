class DenormalizeSubfields < ActiveRecord::Migration
  SUBFIELDS = %w(1 2 3 4 5 a b c d e f g h v)
  def self.up
    drop_table :marc_subfields
    SUBFIELDS.each do |code|
      add_column :marc_fields, "subfield_#{code}", :string
    end
    add_column :documents, :title_without_article, :string
  end

  def self.down
    create_table "marc_subfields", :force => true do |t|
      t.column "code", :string, :limit => 1
      t.column "marc_field_id", :integer
      t.column "body", :string
    end
    SUBFIELDS.each do |code|
      remove_column :marc_fields, "subfield_#{code}"
    end
    remove_column :documents, :title_without_article
  end
end
