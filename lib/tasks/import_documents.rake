
desc 'Import documents from marc.xml dump'
task :import_documents => :environment do
  %x(gunzip dump/dump.xml)
  Document.import_unimarc 'dump/dump.xml'
end