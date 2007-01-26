#require 'lib/import/unimarc_importer'
require 'CSV'

desc 'Import documents from marc.xml dump'
task :import_documents => :environment do

  Responsibility.delete_all
  Document.delete_all
  Author.delete_all    

  Import::UnimarcImporter.new(true).import_binary 'dump/p6470870.LO14451.uni'
  sh 'mysqldump filo_development authors documents responsibilities > db/local-stage0.sql'
#  sh 'mysql filo_development < db/local-stage0.sql'

  Import::UnimarcImporter.new(true).import_xml "dump/dump.xml"
  sh 'mysqldump filo_development authors documents responsibilities > db/local-stage1.sql'

  Import::SpogliImporter.new(true).import "dump/spogli/titoli.csv", "dump/spogli/responsabilita.csv"
  sh 'mysqldump filo_development authors documents responsibilities > db/local-stage2.sql'

  # Non sono riuscito a far lavorare correttamente l'iniziale Č in mysql
  Author.connection.execute("update authors set name = 'Chekhov, Anton Pavlovich' where name = 'Čehov, Anton Pavlovič'")
  Author.connection.execute("update authors set name = 'Eluard, Paul' where name = 'Éluard, Paul'")
end