require 'lib/unimarc_importer'

desc 'Import documents from marc.xml dump'
task :import_documents => :environment do
  %x(gunzip dump/dump.xml)

  MarcField.delete_all
  Document.delete_all
  Author.delete_all    
  UnimarcImporter.new.do_import 'dump/dump.xml'
end