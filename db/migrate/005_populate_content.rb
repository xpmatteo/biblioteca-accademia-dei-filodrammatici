class PopulateContent < ActiveRecord::Migration
  
  def self.add_content(title, name)
    Content.new( :title => title, :name => name, :body => 'todo' ).save
  end
  
  def self.up
    Content.delete_all
    add_content 'La scuola',          'la-scuola'
    add_content 'Profilo storico',    'profilo-storico'
    add_content 'Offerta formativa',  'offerta-formativa'
    add_content 'Corpo docente',      'corpo-docente'
    add_content 'Progetto GEIE',      'progetto-geie'
    add_content 'Bando 2007',         'bando'
    add_content 'Carlo Porta',        'carlo-porta'
    add_content 'Giuseppe Verdi',     'giuseppe-verdi'
    add_content 'Ugo Foscolo',        'ugo-foscolo'
    add_content 'Bando 2007',         'bando-2007'
    add_content 'Spazio diplomati',   'spazio-diplomati'
  end

  def self.down
  end
end
