class Graduate < ActiveRecord::Base                                                     

  validates_presence_of :first_name, :last_name, :graduation_year
  validates_numericality_of :graduation_year, :size, :height_cm, :weight_kg, 
    :only_integer => true, :allow_nil => true
  validates_format_of :email, :with => /^([^@\s]+@([^@\s]+\.)+[a-z]{2,})?$/i
  
  file_column :image, 
    :magick => { :geometry => "400x400>" },
    :root_path => File.join(RAILS_ROOT, "public", "upload"), 
    :web_root => "upload/"
  
  ANAGRAPHIC_ATTRIBUTES = {      
      :first_name => 'Nome',
      :last_name  => 'Cognome',      
      :fiscal_code => 'Codice Fiscale',      
      :graduation_year => 'Anno di diploma',
  }

  ADDRESS_ATTRIBUTES = {
      :home_page_url => 'Home page',      
      :email => 'Email',
      :address => 'Indirizzo',      
      :phone => 'Telefono',      
      :fax => 'Fax',
      :mobile => 'Cellulare',
      :agency => 'Agenzia',
  }

  OTHER_ATTRIBUTES = {
      :height_cm => 'Altezza (cm)',
      :weight_kg => 'Peso (Kg)',
      :eyes => 'Occhi',
      :hair => 'Capelli',
      :size => 'Taglia',      
      :sport => 'Sport',      
      :languages => 'Lingue',
      :dialects => 'Dialetti',      
      :notes => 'Altre note',
  }
  
  def self.graduation_years
    self.find_by_sql('select distinct graduation_year from graduates order by graduation_year').map do |g|
      g.graduation_year
    end
  end
  
  def self.initials     
    sql = 'select distinct upper(left(last_name, 1)) as initial from graduates order by last_name'
    self.find_by_sql(sql).map do |g|
      g.initial
    end
  end
end
