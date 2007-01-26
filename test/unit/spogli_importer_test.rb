require File.dirname(__FILE__) + '/../test_helper'

module Import
  
class SpogliImporterTest < Test::Unit::TestCase
  
  def setup
    Responsibility.delete_all
    Author.delete_all
    Document.delete_all
    @parent = save_document(:title => "IL periodico", :id_sbn => "id_periodico")

    @fixtures_path = File.join(File.dirname(__FILE__), *%w[.. fixtures ])
    @importer = SpogliImporter.new
  end
  
  def test_read_responsibilities
    resp = @importer.read_responsibilities(@fixtures_path + "/spogli-responsibilities.csv")
    assert_equal 4, resp.size
    assert_equal "Lunari, Luigi", resp[0].author_name
    assert_equal "LO11048352", resp[0].document_id_sbn
    assert_equal "CFIV017621", resp[0].author_id_sbn
  end
  
  def test_should_remove_slash_and_author_name_from_title
    assert_equal "Foo", @importer.clean_title("Foo / di Bar")
    assert_equal "Bar", @importer.clean_title("Bar / de Foo")
    assert_equal "Zork", @importer.clean_title("Zork / Foo Bar")
  end
  
  def test_should_keep_info_after_author
    assert_equal "Yepeto; traduzione di Nestor Garay",
      @importer.clean_title("Yepeto / di Roberto Cossa ; traduzione di Nestor Garay")

    assert_equal "Foo. Sei testi di autori contemporanei.",
        @importer.clean_title("Foo / di Bla Bla. ((Sei testi di autori contemporanei.")
  end

  def test_should_not_touch_title_otherwise
    assert_equal "Zork bla", @importer.clean_title("Zork bla")    
  end

  def test_should_remove_asterisk_from_title
    assert_equal "Lo Zork", @importer.clean_title("Lo *Zork")    
  end

  def test_should_remove_asterisk_from_author
    responsibilities = [SpogliImporter::AuthorDocument.new("*John *Doe", "id_autore", "id_spoglio")]
    set = AuthorSet.new(responsibilities)
    assert_equal "John Doe", set.author_of("id_spoglio").name
  end

  def test_should_remove_blank_before_colons_and_semicolons
    assert_equal "Foo: Bar: Baz; Foo", @importer.clean_title("Foo : Bar : Baz ; Foo")    
  end

  def test_complex_title
    original = "Gringoire : commedia in un atto ; Le *furberie di Nerina : commedia in unatto / Teodoro De Banville ; traduzione e presentazione di Giovanni Marcellini"
    expected = "Gringoire: commedia in un atto; Le furberie di Nerina: commedia in unatto; traduzione e presentazione di Giovanni Marcellini"
    assert_equal expected, @importer.clean_title(original)
  end

  def test_read_titles
    titles = @importer.read_titles(@fixtures_path + "/spogli-titles.csv")
    assert_equal 9, titles.size
    assert_equal "CFI0156460", titles[0].parent_id_sbn
    assert_equal "LO11048352", titles[0].id_sbn
    assert_equal "La *bella e la bestia : commedia in due tempi / di Luigi Lunari", titles[0].title
  end

  def test_import_documents
    author = save_author(:name => "John Doe", :id_sbn => "id_autore")

    titles = [SpogliImporter::Title.new("Foo", "id_spoglio", "id_periodico")]
    responsibilities = [SpogliImporter::AuthorDocument.new("John Doe", "id_autore", "id_spoglio")]

    @importer.do_import(titles, responsibilities)

    assert_equal 2, Document.count
    spoglio = Document.find_by_title("Foo")
    assert_not_nil spoglio, "non lo ha trovato"
    assert_equal "id_spoglio", spoglio.id_sbn
    assert_equal @parent, spoglio.parent
    assert_equal "serial", spoglio.hierarchy_type
    assert_equal "serial", spoglio.parent.hierarchy_type
    assert_equal author, spoglio.author
    assert_equal [author], spoglio.names
  end
  
  def test_should_be_able_to_import_documents_without_author
    titles = [SpogliImporter::Title.new("Foo", "id_spoglio", "id_periodico")]
    responsibilities = []

    @importer.do_import(titles, responsibilities)

    spoglio = Document.find_by_title("Foo")
    assert_nil spoglio.author, "author"
    assert_equal [], spoglio.names    
  end

  def test_author_set_find_by_id_spoglio
    responsibilities = [
      SpogliImporter::AuthorDocument.new("John Doe", "id000", "id_spoglio1"),
      SpogliImporter::AuthorDocument.new("Mary Jane", "id111", "id_spoglio2"),
      SpogliImporter::AuthorDocument.new("John Doe", "id000", "id_spoglio3"),
      ]
    set = AuthorSet.new(responsibilities)
    assert_equal "id000", set.author_id_of("id_spoglio1")
    assert_equal "id000", set.author_id_of("id_spoglio3")
    assert_equal "id111", set.author_id_of("id_spoglio2")
  end
  
  def test_author_set_should_find_author_in_db
    author = save_author(:name => "Doe, John", :id_sbn => "id000")
    responsibilities = [
      SpogliImporter::AuthorDocument.new("John Doe", "id000", "id_spoglio1"),
      ]
    set = AuthorSet.new(responsibilities)
    assert_equal author, set.author_of("id_spoglio1")
  end

  def test_author_set_should_create_author_in_db
    responsibilities = [
      SpogliImporter::AuthorDocument.new("John Doe", "id000", "id_spoglio1"),
      ]
    set = AuthorSet.new(responsibilities)

    actual = set.author_of("id_spoglio1")

    assert_not_nil actual, "non ha restituito"
    assert_equal Author.find_by_id_sbn("id000"), actual
  end
  
  private
  def save_document(attributes)
    d = Document.new(attributes)
    assert d.save, d.errors.full_messages.join("; ")
    d
  end

  def save_author(attributes)
    d = Author.new(attributes)
    assert d.save, d.errors.full_messages.join("; ")
    d
  end
end

end # module import