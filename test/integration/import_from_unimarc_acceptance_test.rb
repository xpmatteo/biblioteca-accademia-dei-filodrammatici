require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../import_test_helper'

class ImportFromUnimarcTest < Test::Unit::TestCase
  include ImportTestHelper

  def setup
    Document.delete_all
    Author.delete_all
    Responsibility.delete_all
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
    
    Import::UnimarcImporter.new.import_xml File.dirname(__FILE__) + '/../fixtures/modern.xml'
    @document = Document.find_by_id_sbn('ANA0019058')
    assert_nil                  @document.author
    assert_title                "Teatro elisabettiano: Kyd, Marlowe, Heywood, Marston, Jonson, Webster, Tourneur, Ford"
    assert_publication          "Firenze: Sansoni, stampa 1948"
    assert_physical_description "XXVIII, 1274 p. ; 21 cm."
    assert_notes                "Trad. di Gabriele Baldini. Altra nota"
    assert_national_bibliography_number "1929 4793"
    assert_signature            "S.I 14"
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
    
    Import::UnimarcImporter.new.import_xml File.dirname(__FILE__) + '/../fixtures/modern.xml'
    @document = Document.find_by_id_sbn('MIL0066910')
    assert_author               "Grassi, Paolo <1919-1981>"
    assert_names                ["Abbado, Claudio", "Grassi, Paolo <1919-1981>", "Pozzi, Emilio", "Strehler, Giorgio"]
    assert_title                "Quarant'anni di palcoscenico; a cura di Emilio Pozzi; in appendice: lettere di Giorgio Strehler e Claudio Abbado"
    assert_publication          "Milano: Mursia, 1977"
    assert_physical_description "2. ed.; 368 p. : \\16] c. di tav. ; 22 cm."
    assert_collection_volume    "11"
    assert_collection           "Voci, uomini e tempi; 11"
    assert_signature            "O.IV 13"
  end
  
  def test_import_from_unimarc_binary_works
    Import::UnimarcImporter.new.import_binary File.dirname(__FILE__) + '/../fixtures/modern.uni'
    assert_not_nil Document.find_by_original_title('Venezia 1795-1802 : la cronologia degli spettacoli e il Giornale dei teatri / Franco Rossi'), "non ha importato venezia"
    assert_not_nil Document.find_by_original_title('Drammi lirici ed altri componimenti poetici / di Virginia Fedeli Galli'), "non ha importato virginia"
  end
  
  def test_import_issued_with
    Import::UnimarcImporter.new.import_xml File.dirname(__FILE__) + '/../fixtures/issued_with.xml'
    assert_not_nil @document = Document.find_by_id_sbn('LO10865597'), "non trovato"
    assert_title 'Florilegio drammatico francese. Tomo 2'
    assert_collection 'Florilegio drammatico francese; 2'
    assert_issued_with ["La procura, e la convalescenza", "La camera verde ossia le disgrazie d'un amante fortunato"]
    
    @document = @document.children[1]
    assert_equal '001LO10878361', @document.id_sbn
    assert_author "Mazères, Édouard Joseph Ennemond"
    assert_names ["Mazères, Édouard Joseph Ennemond", "Théaulon de Lambert, Marie"]
    assert_hierarchy_type "issued_with"
    assert_equal 'CLIAV009431', @document.names[0].id_sbn
    assert_equal 'DLIAV026126', @document.names[1].id_sbn
  end
  
  def test_responsibilities_are_denormalized
    Import::UnimarcImporter.new.import_xml File.dirname(__FILE__) + '/../fixtures/modern.xml'
    @document = Document.find_by_id_sbn('MIL0066910')
    assert_responsibilities_denormalized "Grassi, Paolo <1919-1981>; Pozzi, Emilio; Strehler, Giorgio; Abbado, Claudio"
  end
  
  def test_should_extract_place_publisher_and_year_and_century
    import_this_tag <<-TAG
      <datafield tag='210' ind1=' ' ind2=' '>
        <subfield code='a'>Roma</subfield>
        <subfield code='c'>A. F. Formiggini</subfield>
        <subfield code='d'>stampa 1929</subfield>
      </datafield>
    TAG
    assert_place "Roma"
    assert_publisher "A. F. Formiggini"
    assert_year 1929
    assert_century 20
  end
  
  def test_should_ignore_brackets_in_place
    import_this_tag <<-TAG
      <datafield tag='210' ind1=' ' ind2=' '>
        <subfield code='a'>[Milano]</subfield>
      </datafield>
    TAG
    assert_place "Milano"
  end
  
  def test_should_not_crash_on_missing_year
    import_this_tag <<-TAG
      <datafield tag='210' ind1=' ' ind2=' '>
        <subfield code='d'>\s.d.]</subfield>
      </datafield>
    TAG
    assert_year nil
    assert_century nil
  end
  
  def test_should_record_century_if_given
    import_this_tag <<-TAG
      <datafield tag='210' ind1=' ' ind2=' '>
        <subfield code='d'>18-?</subfield>
      </datafield>
    TAG
    assert_year nil
    assert_century 19, "con -?"    
  end
  
  def test_should_record_century_if_given
    import_this_tag <<-TAG
      <datafield tag='210' ind1=' ' ind2=' '>
        <subfield code='d'>\\19..]</subfield>
      </datafield>
    TAG
    assert_year nil
    assert_century 20, "con .."
  end
  
  def test_should_record_first_place_if_many
    import_this_tag <<-TAG
      <datafield tag='210' ind1=' ' ind2=' '>
        <subfield code='a'>Roma</subfield>
        <subfield code='a'>Milano</subfield>
        <subfield code='c'>A. F. Formiggini</subfield>
        <subfield code='d'>stampa 1929</subfield>
      </datafield>
    TAG
    assert_place "Roma"
  end
  
  def test_should_rewrite_iccu_codes_to_polo_lombardo_style
    import <<-SCHEDA
    <collection>
      <record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>03225nam0a2200517  I450 </leader>
        <controlfield tag="001">IT\\ICCU\\BVE\\0013119</controlfield>
        <datafield tag="200" ind1="1" ind2=" ">
          <subfield code="a">Cronache teatrali del primo Novecento</subfield>
        </datafield>    
      </record>
    </collection>
    SCHEDA
    assert_equal "BVE0013119", @document.id_sbn
  end
  
  def test_should_find_author_even_if_it_was_recorded_using_polo_lombardo_id_style
    import <<-SCHEDA
    <collection>
      <record>
        <leader>01102nam  2200265   45  </leader>
        <controlfield tag='001'>AQ10007044</controlfield>
        <datafield tag='200' ind1='1' ind2=' '>
          <subfield code='a'>L&apos;attore biomeccanico</subfield>
        </datafield>
        <datafield tag='700' ind1=' ' ind2='1'>
          <subfield code='a'>Mejerhold, Salvato Prima</subfield>
          <subfield code='3'>CIEIV000637</subfield>
        </datafield>    
      </record>
    </collection>
    SCHEDA

    import <<-SCHEDA
    <collection>
      <record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>03225nam0a2200517  I450 </leader>
        <controlfield tag="001">IT\\ICCU\\BVE\\0013119</controlfield>
        <datafield tag="200" ind1="1" ind2=" ">
          <subfield code="a">Cronache teatrali del primo Novecento</subfield>
        </datafield>    
        <datafield tag="700" ind1=" " ind2="1">
          <subfield code="a">Mejerhold, Vsevolod Emilevic</subfield>
          <subfield code="3">IT\\ICCU\\IEIV\\000637</subfield>
          <subfield code="4">070</subfield>
        </datafield>  
      </record>
    </collection>
    SCHEDA
    assert_title "Cronache teatrali del primo Novecento"
    assert_author "Mejerhold, Salvato Prima"
    assert_equal 1, Author.count
  end

  def test_should_ignore_duplicate_entries
    import <<-SCHEDA
    <collection>
      <record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>03225nam0a2200517  I450 </leader>
        <controlfield tag="001">BVE0013119</controlfield>
        <datafield tag="200" ind1="1" ind2=" ">
          <subfield code="a">Cronache teatrali del primo Novecento</subfield>
        </datafield>    
      </record>
    </collection>
    SCHEDA
    import <<-SCHEDA
    <collection>
      <record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>03225nam0a2200517  I450 </leader>
        <controlfield tag="001">IT\\ICCU\\BVE\\0013119</controlfield>
        <datafield tag="200" ind1="1" ind2=" ">
          <subfield code="a">Foo bar baz</subfield>
        </datafield>    
      </record>
    </collection>
    SCHEDA
    assert_equal 1, Document.count
    assert_equal "Cronache teatrali del primo Novecento", @document.title
  end
  
  def test_should_ignore_asterisk
    import <<-SCHEDA
    <collection>
      <record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>03225nam0a2200517  I450 </leader>
        <controlfield tag="001">BVE0013119</controlfield>
        <datafield tag="200" ind1="1" ind2=" ">
          <subfield code="a">HL&apos; IAdargonte</subfield>
        </datafield>    
        <datafield tag="225" ind1="0" ind2=" ">
          <subfield code="a">HLes Imeilleurs auteurs classiques francais et etrangers</subfield>
        </datafield>
        <datafield tag="410" ind1=" " ind2="1">
          <subfield code="1">001IT\ICCU\LO1\0258764</subfield>
          <subfield code="1">2001 </subfield>
          <subfield code="a">HLes Imeilleurs auteurs classiques francais et etrangers</subfield>
        </datafield>
      </record>
    </collection>
    SCHEDA
    assert_title "L' Adargonte"
    assert_collection_name "Les meilleurs auteurs classiques francais et etrangers"
  end
  
  def test_should_cleanup_title_and_remember_original_title
    import <<-SCHEDA
    <collection>
      <record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>03225nam0a2200517  I450 </leader>
        <controlfield tag="001">BVE0013119</controlfield>
        <datafield tag="200" ind1="1" ind2=" ">
          <subfield code='a'>Quarant&apos;anni di palcoscenico</subfield>
          <subfield code='f'>Paolo Grassi</subfield>
          <subfield code='g'>a cura di Emilio Pozzi</subfield>
          <subfield code='g'>in appendice: lettere di Giorgio Strehler e Claudio Abbado</subfield>
        </datafield>    
      </record>
    </collection>
    SCHEDA

    assert_title "Quarant'anni di palcoscenico; a cura di Emilio Pozzi; in appendice: lettere di Giorgio Strehler e Claudio Abbado"
    assert_original_title "Quarant'anni di palcoscenico / Paolo Grassi ; a cura di Emilio Pozzi ; in appendice: lettere di Giorgio Strehler e Claudio Abbado"
  end
  
  def test_scheda_antica_clotario
    # Abbati, Giovanni Battista
    # Il Clotario tragedia da rappresentarsi nel teatro Grimani di S. Samuele l'anno 1723 / [Gio.Battista Abbati]. Consacrata all'illustrissimo, ed eccellentissimo sig. Giuseppe Lini patrizio veneto.
    # In Venezia: appresso Biasio Maldura. Si vende da Carlo Bonarigo in Spadaia
    # 72 p. ; 12o. 
    # Il nome dell'A. figura nella pref .
    # Segn.: A-C12;  Impronta - 'ee, lido a.a, AcTe (3) 1723 (Q)
    # 
    # Abbati, Giovanni Battista ; Buonarrigo, Carlo ; Maldura, Biagio
    # IT\ICCU\BVEE\025199    
  
    Import::UnimarcImporter.new.import_xml File.dirname(__FILE__) + '/../fixtures/ancient.xml'
    assert_not_nil @document = Document.find_by_id_sbn("BVEE025199"), "not found"
    assert_author               "Abbati, Giovanni Battista"
    assert_title                "Il Clotario tragedia da rappresentarsi nel teatro Grimani di S. Samuele l'anno 1723 / [Gio.Battista Abbati]. Consacrata all'illustrissimo, ed eccellentissimo sig. Giuseppe Lini patrizio veneto"
    assert_publication          "In Venezia: appresso Biasio Maldura. Si vende da Carlo Bonarigo in Spadaria"
    assert_physical_description "72 p. ; 12o."
    assert_notes                "Il nome dell'A. figura nella pref"
    assert_footprint            "'ee, lido a.a, AcTe (3) 1723 (Q)"
    assert_names                ["Abbati, Giovanni Battista", "Buonarrigo, Carlo", "Maldura, Biagio"]
  end
  
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
  #   assert_publication            "Venezia, 1754!"
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
  #   assert_publication            "In Venetia : presso Angelo Saluadori ; si vendono in Pesaro : all'insegna della Venetia, 1629"
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
  #     for field in %w(title, publication, physical_description, notes, numbers, signature)
  #       # assert_equal document.title, document.sbn_title
  #       assert_equal document.attributes[field.to_sym], document.attributes[("sbn_" + field).to_sym]
  #     end
  #   end
  # end
  # 
end
