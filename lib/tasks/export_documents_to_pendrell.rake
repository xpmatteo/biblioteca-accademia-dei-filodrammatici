
desc 'Export documents to Pendrell'
task :export_documents_to_pendrell do

  sh 'ssh pendrell.textdrive.com mysql -pPivNabMa filodr < db/local-stage4.sql'
end