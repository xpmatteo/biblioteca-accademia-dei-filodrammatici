
module Import
  
  class SpogliImporter < Importer
    AuthorDocument = Struct.new(:author_name, :author_id_sbn, :document_id_sbn)
    Title = Struct.new(:title, :id_sbn, :parent_id_sbn)

    attr_accessor :verbose
  
    def read_responsibilities(responsibilities_path)
      result = []
      count = 0
      CSV::Reader.parse(File.open(responsibilities_path, 'rb')) do |row|
        result << AuthorDocument.new(row[5], row[2], row[0]) unless count == 0
        count += 1
      end
      result
    end
  
    def read_titles(titles_path)
      result = []
      count = 0
      CSV::Reader.parse(File.open(titles_path, 'rb')) do |row|
        result << Title.new(row[4], row[2], row[0]) unless count == 0
        count += 1
      end
      result
    end
  
    def do_import(titles, responsibilities)
      authors = AuthorSet.new(responsibilities)
      count = 0
      titles.each do |title|
        parent = Document.find_by_id_sbn(title.parent_id_sbn)
        raise "parent not found: #{title.parent_id_sbn}" unless parent
        author = authors.author_of(title.id_sbn)
      
        d = Document.new(:original_title => title.title, 
                         :title => clean_title(title.title), 
                         :id_sbn => title.id_sbn)
        d.parent = parent
        d.hierarchy_type = "serial"
        d.author = author
        parent.update_attribute(:hierarchy_type, "serial")
        d.save || (puts "cannot save spoglio: #{d.id_sbn}: #{d.errors.full_messages}"; next)
      
        log "no author for #{d.id_sbn}: #{d.title}" unless author  
        log count.to_s 
        count += 1
      end
    end

    def import(titles_path, responsibilities_path)
      titles = read_titles(titles_path)
      responsibilities = read_responsibilities(responsibilities_path)
      do_import(titles, responsibilities)
    end  
  end

  class AuthorSet
  
    def initialize(responsibilities)
      @index = {}
      responsibilities.each do |resp|
        @index[resp.document_id_sbn] = resp
      end
    end
  
    def author_id_of(id_spoglio)
      @index[id_spoglio].author_id_sbn
    end

    def author_of(id_spoglio)
      resp = @index[id_spoglio]
      return nil unless resp
      author = Author.find_by_id_sbn(resp.author_id_sbn)
      return author if author
      author = Author.new(:name => resp.author_name.gsub("*", ""), :id_sbn => resp.author_id_sbn)
      author.save || (raise "cannot save author: " + author.errors.full_messages.join("; "))
      author
    end
  end
  
end