include Unimarc

desc 'Import documents from marc.xml dump'
task :import_documents => :environment do
  %x(gunzip dump/dump.xml)
  Unimarc::do_import 'dump/dump.xml'
end