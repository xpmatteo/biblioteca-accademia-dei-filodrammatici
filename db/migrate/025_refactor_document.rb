class RefactorDocument < ActiveRecord::Migration
  COLUMNS = %w(title publication notes signature footprint physical_description 
                footnote national_bibliography_number collection_name collection_volume)
  def self.up
    COLUMNS.each do |column|
      begin
        add_column :documents, column.to_sym, :string
      rescue 
        puts $!
      end
    end
    
    add_column :documents, :author_id, :integer
    
    begin
      drop_table "marc_fields"
    rescue
    end
    
    create_table :responsibilities, :force => true do |t|
      t.column :author_id,    :integer
      t.column :document_id,  :integer
      t.column :unimarc_tag,  :string
    end    
  end

  def self.down
    COLUMNS.each do |column|
      begin        
        remove_column :documents, column.to_sym
      rescue 
        puts $!
      end
    end 
    
    remove_column :documents, :author_id
    
    begin
      drop_table "responsibilities"
    rescue
      puts $!
    end
  end
end
