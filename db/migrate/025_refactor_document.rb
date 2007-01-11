class RefactorDocument < ActiveRecord::Migration
  COLUMNS = %w(title publisher notes signature footprint physical_description 
                footnote national_bibliography_number)
  def self.up
    COLUMNS.each do |column|
      begin
        add_column :documents, column.to_sym, :string
      rescue 
        puts $!
      end
    end
    
    begin
      drop_table "marc_fields"
    rescue
      puts $!
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
    
    begin
      drop_table "responsibilities"
    rescue
      puts $!
    end
  end
end
