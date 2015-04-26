class DropTableAuthorships < ActiveRecord::Migration
  def self.up
    drop_table :authorships
  end

  def self.down
    create_table "authorships", :force => true do |t|
      t.column "document_id", :integer
      t.column "author_id", :integer
      t.column "type", :string
    end
  end
end
