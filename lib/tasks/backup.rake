
desc 'Backup database'
task :backup do
  dump_file = "db/filo-backup.`date '+%Y%m%d'`.sql"
#  sh "ssh pendrell.textdrive.com mysqldump --skip-lock-tables -umatteo -pPivNabMa filodr --add-drop-table > #{dump_file}"
  sh "rsync -e ssh -r --progress -v pendrell.textdrive.com:domains/accademiadeifilodrammatici.it/versions/shared/upload bak/upload"
end