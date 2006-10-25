# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 22) do

  create_table "authors", :force => true do |t|
    t.column "name", :string
    t.column "id_sbn", :string
  end

  create_table "contents", :force => true do |t|
    t.column "title", :string
    t.column "name", :string
    t.column "body", :text
    t.column "image", :string
  end

  create_table "documents", :force => true do |t|
    t.column "id_sbn", :string
    t.column "title_without_article", :string
  end

  create_table "graduates", :force => true do |t|
    t.column "first_name", :string
    t.column "last_name", :string
    t.column "born_on", :date
    t.column "fiscal_code", :string, :limit => 16
    t.column "graduation_year", :integer
    t.column "home_page_url", :string
    t.column "email", :string
    t.column "address", :string
    t.column "phone", :string
    t.column "fax", :string
    t.column "mobile", :string
    t.column "agency", :string
    t.column "height_cm", :integer
    t.column "weight_kg", :integer
    t.column "eyes", :string
    t.column "hair", :string
    t.column "size", :integer
    t.column "sport", :string
    t.column "languages", :string
    t.column "dialects", :string
    t.column "notes", :string
    t.column "curriculum", :text
    t.column "image", :string
  end

  create_table "marc_fields", :force => true do |t|
    t.column "tag", :string, :limit => 3
    t.column "document_id", :integer
    t.column "subfield_1", :string
    t.column "subfield_2", :string
    t.column "subfield_3", :string
    t.column "subfield_4", :string
    t.column "subfield_5", :string
    t.column "subfield_a", :string
    t.column "subfield_b", :string
    t.column "subfield_c", :string
    t.column "subfield_d", :string
    t.column "subfield_e", :string
    t.column "subfield_f", :string
    t.column "subfield_g", :string
    t.column "subfield_h", :string
    t.column "subfield_v", :string
  end

  add_index "marc_fields", ["subfield_3"], :name => "marc_fields_subfield_3_index"
  add_index "marc_fields", ["document_id"], :name => "marc_fields_document_id_index"
  add_index "marc_fields", ["subfield_3"], :name => "foobar"

  create_table "menu_items", :force => true do |t|
    t.column "parent_id", :integer
    t.column "title", :string
    t.column "controller", :string
    t.column "item_id", :integer
    t.column "position", :integer
  end

  create_table "news", :force => true do |t|
    t.column "title", :string
    t.column "body", :text
    t.column "created_at", :datetime
  end

  create_table "teachers", :force => true do |t|
    t.column "first_name", :string
    t.column "last_name", :string
    t.column "course_name", :string
    t.column "curriculum", :text
    t.column "for_seminar", :boolean
    t.column "image", :string
  end

end
