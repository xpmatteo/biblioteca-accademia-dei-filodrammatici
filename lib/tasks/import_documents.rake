require 'lib/unimarc'
include Unimarc

desc 'Import documents from marc.xml dump'
task :import_documents => :environment do
  %x(gunzip dump/dump.xml)

  MarcField.delete_all
  Document.delete_all
  Author.delete_all    
  Unimarc::do_import 'dump/dump.xml'
end