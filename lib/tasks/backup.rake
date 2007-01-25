
desc 'Backup database'
task :backup_filo do
  dump_file = "db/filo-backup.`date '+%Y%m%d'`.sql"
  sh "ssh pendrell.textdrive.com mysqldump --skip-lock-tables -umatteo -pPivNabMa filodr --add-drop-table > #{dump_file}"
end