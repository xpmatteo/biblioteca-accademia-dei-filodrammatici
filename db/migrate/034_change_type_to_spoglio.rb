class ChangeTypeToSpoglio < ActiveRecord::Migration
  class Document < ActiveRecord::Base; end

  def self.up
    serials = Document.find_all_by_document_type("serial")
    serial_ids = serials.map(&:id).join(", ")
    execute <<-SQL
      update documents set document_type = 'in-serial' 
      where  parent_id in (#{serial_ids})
    SQL
  end

  def self.down
    execute "update documents set document_type = 'monograph' where document_type = 'in-serial'"
  end
end
