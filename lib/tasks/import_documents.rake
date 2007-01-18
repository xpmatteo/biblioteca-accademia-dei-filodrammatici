require 'lib/unimarc_importer'

desc 'Import documents from marc.xml dump'
task :import_documents => :environment do

  Responsibility.delete_all
  Document.delete_all
  Author.delete_all    
  importer = UnimarcImporter.new
  importer.verbose = true
  importer.import_binary 'dump/p6470870.LO14451.uni'

  # Non sono riuscito a far lavorare correttamente l'iniziale Č in mysql
  Author.connection.execute("update authors set name = 'Chekhov, Anton Pavlovich' where name = 'Čehov, Anton Pavlovič'")
  Author.connection.execute("update authors set name = 'Eluard, Paul' where name = 'Éluard, Paul'")  
end