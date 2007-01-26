cat dump/dump.xml  | ruby -n -e 'puts $1 if /["''](4..)["'']/'  | sort | uniq -c | sort -nr | less
