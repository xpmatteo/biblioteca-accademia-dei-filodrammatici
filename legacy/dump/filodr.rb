require 'zoom'

ZOOM::Connection.open('opac.sbn.it', 3950) do |conn|
    conn.database_name = 'nopac'
    conn.preferred_record_syntax = 'UNIMARC'
#    rset = conn.search('@attr 1=7 0253333490')
#    rset = conn.search('@and @attr 1=4 "interfacce utente" @attr 1=3088 "MI1173"')
#    rset = conn.search('@attr 1=3088 "MI1173"') # poli
    rset = conn.search('@attr 1=3088 "MI1181"') # filo
    
#    rset = conn.search('@attr 1=4 "Amleto"')
#    rset = conn.search('@attr 1=4 "Interfacce utente"')
    p rset.size
    
    # we want full records
    rset.set_option "elementSetName", "F"
    rset.set_option "charset", "ISO-8859-1"
    p rset[0]
    
    for i in (0...rset.size)
      p rset[i]
      puts
    end
    puts "<records>"
    for i in (0...rset.size)
      puts rset[i].xml
      puts
    end
    puts "</records>"
end
