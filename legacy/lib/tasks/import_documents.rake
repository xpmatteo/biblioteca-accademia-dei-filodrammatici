
def dump_documents(stage)
  sh "mysqldump filo_development authors documents responsibilities publishers_emblems > db/local-stage#{stage}.sql"  
end

desc 'Import documents from marc.xml dump'
task :import_documents => :environment do

  # Responsibility.delete_all
  # Document.delete_all
  # Author.delete_all    
  # 
  # Import::UnimarcImporter.new(true).import_binary 'dump/p6470870.LO14451.uni'
  # dump_documents(0)
  # 
  # Import::UnimarcImporter.new(true).import_xml "dump/dump.xml"
  # dump_documents(1)
  # 
  # Import::SpogliImporter.new(true).import "dump/spogli/titoli.csv", "dump/spogli/responsabilita.csv"
  # dump_documents(2)
  # 
  # Author.consolidate!
  # dump_documents(3)
  # 
  # sh 'script/runner script/remove_empty_authors.rb'
  # Author.connection.execute "update authors set name = 'Chekhov, Anton Pavlovich' where name = 'Čehov, Anton Pavlovič'"
  # Author.connection.execute "update authors set name = 'Eluard, Paul' where name = 'Éluard, Paul'"
  Author.connection.execute "update documents set publishers_emblem_id = null 
                              where publishers_emblem_id = (select id from publishers_emblems where description = 'MARCA NON CONTROLLATA')"
  dump_documents(4)


end