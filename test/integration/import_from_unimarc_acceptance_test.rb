require File.dirname(__FILE__) + '/../test_helper'

class ImportFromUnimarcTest < Test::Unit::TestCase

  def setup
    Document.delete_all
    Author.delete_all
    UnimarcImporter.new.do_import File.dirname(__FILE__) + '/../fixtures/modern.xml'
  end

  def zztest_find_subcodes
    reader = RMARC::MarcXmlReader.new(File.dirname(__FILE__) + '/../../dump/lispa-2006-12-10.xml')
    count = 0
    while reader.has_next
      record = reader.next()
      record.each do |field|
        if field.tag == '210'
          if field.subfields.find {|s| %w(b e f g h).member? s.code }
            p field
            count += 1
            return if count == 10
          end
        end
      end
      print "."
      $stdout.flush
    end    
  end

  def test_scheda_moderna_teatro_elisabettiano
    # Teatro elisabettiano : Kyd, Marlowe, Heywood, Marston, Jonson, Webster, Tourneur, Ford
    # Firenze : Sansoni, stampa 1954 
    # XXVIII, 1274 p. ; 21 cm
    # Trad. di Gabriele Baldini ... [et al.!, sotto la direzione di Mario Praz
    # 
    # I grandi classici stranieri
    # Bibliografia Nazionale - 1955 3018
    # Praz, Mario
    # Baldini, Gabriele 
    # IT\ICCU\AQ1\0031672
    
    @document = Document.find_by_id_sbn('ANA0019058')
    assert_nil                  @document.author
    assert_title                "Teatro elisabettiano : Kyd, Marlowe, Heywood, Marston, Jonson, Webster, Tourneur, Ford / [sotto la direzione di Mario Praz]"
    assert_publisher            "Firenze : Sansoni, stampa 1948"
    assert_physical_description "XXVIII, 1274 p. ; 21 cm."
    assert_notes                "Trad. di Gabriele Baldini. Altra nota"
    assert_national_bibliography_number "1929 4793"
    assert_signature            "S.I 14"
    
    assert_not_nil Author.find_by_name("Praz, Mario")
    assert_names                ["Praz, Mario"]
    assert_collection           "I grandi classici stranieri"
  end
  
  def test_scheda_moderna_quarantanni_di_palcoscenico
    # Grassi, Paolo <1919-1981>
    # Quarant'anni di palcoscenico / Paolo Grassi ; a cura di Emilio Pozzi ; in appendice: lettere di Giorgio Strehler e Claudio Abbado 
    # Milano : Mursia, 1977;   
    # 
    # 2. ed.;  368 p. : \16! c. di tav. ; 22 cm.
    # Voci, uomini e tempi ; 11
    # 
    # Abbado, Claudio ; Grassi, Paolo <1919-1981> ; Pozzi, Emilio ; Strehler, Giorgio
    # IT\ICCU\MIL\0066910
    
    @document = Document.find_by_id_sbn('MIL0066910')
    assert_author               "Grassi, Paolo <1919-1981>"
    assert_names                ["Abbado, Claudio", "Grassi, Paolo <1919-1981>", "Pozzi, Emilio", "Strehler, Giorgio"]
    assert_title                "Quarant'anni di palcoscenico / Paolo Grassi ; a cura di Emilio Pozzi ; in appendice: lettere di Giorgio Strehler e Claudio Abbado"
    assert_publisher            "Milano : Mursia, 1977"
    assert_physical_description "2. ed.;  368 p. : \16! c. di tav. ; 22 cm."
    assert_notes                "Trad. di Gabriele Baldini ... [et al.!, sotto la direzione di Mario Praz"
    assert_collection           "Voci, uomini e tempi ; 11"
    assert_signature            "???"
  end
  

  # def test_scheda_antica_clotario
  #   # Abbati, Giovanni Battista
  #   # Il Clotario tragedia da rappresentarsi nel teatro Grimani di S. Samuele l'anno 1723 / [Gio.Battista Abbati]. Consacrata all'illustrissimo, ed eccellentissimo sig. Giuseppe Lini patrizio veneto.
  #   # In Venezia: appresso Biasio Maldura. Si vende da Carlo Bonarigo in Spadaia
  #   # 72 p. ; 12o. 
  #   # Il nome dell'A. figura nella pref .
  #   # Segn.: A-C12;  Impronta - 'ee, lido a.a, AcTe (3) 1723 (Q)
  #   # 
  #   # Abbati, Giovanni Battista ; Buonarrigo, Carlo ; Maldura, Biagio
  #   # IT\ICCU\BVEE\025199    
  # 
  #   @document = Document.find_by_id_sbn('???')
  #   assert_author               "Abbati, Giovanni Battista"
  #   assert_title                "Il Clotario tragedia da rappresentarsi nel teatro Grimani di S. Samuele l'anno 1723 / [Gio.Battista Abbati]. Consacrata all'illustrissimo, ed eccellentissimo sig. Giuseppe Lini patrizio veneto."
  #   assert_publisher            "In Venezia: appresso Biasio Maldura. Si vende da Carlo Bonarigo in Spadaia"
  #   assert_physical_description "72 p. ; 12o."
  #   assert_notes                "Il nome dell'A. figura nella pref ."
  #   # tag 012 subfield a
  #   assert_footprint            "'ee, lido a.a, AcTe (3) 1723 (Q)"
  #   assert_names                ["Abbati, Giovanni Battista", "Buonarrigo, Carlo", "Maldura, Biagio"]
  #   assert_signature            "A-C12"
  # end
  # 
  # def test_scheda_antica_li_pregiudizj
  #   # Bianchi, Antonio <1720-1775>
  #   # Li pregiudizj della paterna prevenzione o sia l'onesta premiata. Commedia II
  #   # Venezia, 1754!
  #   # 71-490 p. ; 18 cm
  #   # 
  #   # Opera non completamente identificata per la mancanza delle prime 70 pagine contenenti la prima commedia, Il Tutore infedele, come si legge nella lettera dedicatoria dell'autore a i lettori a pag. 76
  #   # Il luogo, la data e il nome dell'autore sono indicati a pag. 75 in fondo alla lettera dedicatoria a Sua Eccellenza il Sig. Marin Zorzi
  #   # L'opera contiene inoltre le commedie terza, quarta, quinta e sesta : Il buon parente ; Il segretario domestico ; Il sensale da servi. Ovvero la moglie tollerante ; La vedova di Moliere o sia la vanarella
  #   # 
  #   # Bianchi , Antonio <1720-1775>
  #   # ￼[Pubblicato con] Il buon parente. Commedia III  
  #   #  Il segretario domestico. Commedia IV 
  #   # Il sensale da servi. Ovvero la moglie tollerante. Commedia V 
  #   # 
  #   # IT\ICCU\LO1E\021147
  #   
  #   @document = Document.find_by_id_sbn('LO1E021147')
  #   assert_author               "Bianchi, Antonio <1720-1775>"
  #   assert_title                "Li pregiudizj della paterna prevenzione o sia l'onesta premiata. Commedia II"
  #   assert_publisher            "Venezia, 1754!"
  #   assert_physical_description "71-490 p. ; 18 cm"
  #   # tre occorrenze del tag 300; da concatenare con ". "
  #   assert_notes                "Opera non completamente identificata per la mancanza delle prime 70 pagine contenenti la prima commedia, Il Tutore infedele, come si legge nella lettera dedicatoria dell'autore a i lettori a pag. 76. Il luogo, la data e il nome dell'autore sono indicati a pag. 75 in fondo alla lettera dedicatoria a Sua Eccellenza il Sig. Marin Zorzi. L'opera contiene inoltre le commedie terza, quarta, quinta e sesta : Il buon parente ; Il segretario domestico ; Il sensale da servi. Ovvero la moglie tollerante ; La vedova di Moliere o sia la vanarella."
  #   assert_collection           nil
  #   assert_names                ["Bianchi, Antonio <1720-1775>"]
  #   assert_signature            "???"
  #   # tre occorrenze del tag 423
  #   assert_issued_with          ["Il buon parente. Commedia III", "Il segretario domestico. Commedia IV", "Il sensale da servi. Ovvero la moglie tollerante. Commedia V"]
  # end
  # 
  # def test_scheda_antica_il_parto_finto
  #   # Raimondo, Marco Antonio <fl. 1625>
  #   # Il parto finto, comedia del sign. Marcantonio Raimondo romano
  #   # In Venetia : presso Angelo Saluadori ; si vendono in Pesaro : all'insegna della Venetia, 1629
  #   # 142, [2] p. ; 12°
  #   # Marca di Salvadori (colomba. Motto: Salvia. Salvat.) sul front.
  #   # Segn.: A-F12,  F12 bianca.
  #   # Impronta - erel die. uiin teCo (3) 1629 (A)
  #   # 
  #   # Raimondo, Marco Antonio <fl. 1625>
  #   # Salvadori, Angelo
  #   # Alla insegna della Venetia
  #   # 
  #   # IT\ICCU\BVEE\022732
  #   
  #   @document = Document.find_by_id_sbn('BVEE022732')
  #   assert_author               "Raimondo, Marco Antonio <fl. 1625>"
  #   assert_title                "Il parto finto, comedia del sign. Marcantonio Raimondo romano"
  #   assert_publisher            "In Venetia : presso Angelo Saluadori ; si vendono in Pesaro : all'insegna della Venetia, 1629"
  #   assert_physical_description "142, [2] p. ; 12°"
  #   assert_notes                "Marca di Salvadori (colomba. Motto: Salvia. Salvat.) sul front."
  #   assert_collection           nil
  #   assert_signature            "A-F12,  F12 bianca."
  #   assert_footprint            "erel die. uiin teCo (3) 1629 (A)"
  #   assert_names                ["Raimondo, Marco Antonio <fl. 1625>", "Salvadori, Angelo", "Alla insegna della Venetia"]
  #   assert_issued_with          nil
  # end
  # 
  # def test_should_import_all_authors
  #   authors = Author.find(:all, :order => 'name').map { |a| a.name }
  #   assert_equal ["Abbado, Claudio", "Grassi, Paolo <1919-1981>", "Pozzi, Emilio", "Praz, Mario", "Strehler, Giorgio"],
  #     authors
  # end
  # 
  # def test_should_keep_sbn_data_in_duplicate_fields
  #   for document in Document.find(:all)
  #     for field in %w(title, publisher, physical_description, notes, numbers, signature)
  #       # assert_equal document.title, document.sbn_title
  #       assert_equal document.attributes[field.to_sym], document.attributes[("sbn_" + field).to_sym]
  #     end
  #   end
  # end
  # 
private

  def assert_author(expected)
    assert_equal expected, @document.author.name, "autore diverso da atteso"
  end

  def assert_collection(expected)
    assert_equal expected, @document.collection.name, "collezione diversa da atteso"
  end
  
  def assert_names(expected)
    assert_equal expected, @document.names.map {|n| n.name} , "nomi diversi da atteso"
  end
  
  def assert_issued_with(expected)
    assert_equal expected, @document.issued_with.map {|n| n.title} , "issued_with diversi da atteso"
  end

  %w(title publisher notes signature footprint physical_description signature footnote 
    national_bibliography_number title_without_article).each do |attribute|
    self.class_eval <<-END
      def assert_#{attribute}(expected)
        assert_equal expected, @document.attributes["#{attribute}"], "#{attribute} diverso da atteso"
      end
    END
  end
  
end
