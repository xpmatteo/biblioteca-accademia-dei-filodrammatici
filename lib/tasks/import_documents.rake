
desc 'Import documents from marc.xml dump'
task :import_documents => :environment do
  Document.import_unimarc 'dump/dump.xml'
end