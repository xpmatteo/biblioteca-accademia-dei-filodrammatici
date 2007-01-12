require 'lib/unimarc_importer'

desc 'Import documents from marc.xml dump'
task :import_documents => :environment do

  Responsibility.delete_all
  Document.delete_all
  Author.delete_all    
  UnimarcImporter.new.do_import 'dump/lispa-2006-12-10-2.xml'
  UnimarcImporter.new.do_import 'dump/lispa-2006-12-10.xml'
end