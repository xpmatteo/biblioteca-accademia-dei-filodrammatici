require 'rmarc'

class UnimarcImporter
  
  attr_accessor :field
  attr_writer :verbose
  
  def import_xml(filename)
    do_import RMARC::MarcXmlReader.new(filename)
  end
  
  def import_binary(filename)
    do_import RMARC::MarcStreamReader.new(filename)
  end
  
  def do_import(reader)
    count = 0
    while reader.has_next
      record = reader.next()
      d = Document.new      
      @names = []
      @children = []
      record.each do |field|
        @field = field
        parse_field(d)
      end
      d.save || (raise "cannot save: " + d.errors.full_messages.join(", "))
      add_names(d)
      add_children(d)
      count += 1
      puts count if @verbose
      $stdout.flush
    end
  rescue
    p d
    puts $!
  end
  
  def parse_field(d)
    case @field.tag
    when '001' 
      d.id_sbn = @field.data
    when '020'
      d.national_bibliography_number = sub('b') if sub('a') == "IT"
    when '200'
      d.title = construct_title
    when '205'
      d.physical_description = sub('a')
    when '210'
      d.publication = construct_publisher
    when '215'
      d.physical_description = append(d.physical_description, construct_physical_description)
    when '225'
      d.collection_name = sub_unless_nil('a')
      d.collection_volume = sub_unless_nil('v')
    when '300'
      if d.notes
        d.notes += ". " + sub('a')
      else
        d.notes = sub('a')
      end
    when '423'
      create_child_document
    when '700', '701', '702', '710', '711', '712'
      author = create_or_find_author(sub('3'), sub('a'))
      @names << author
      d.author = author if '700' == @field.tag
    when '950'
      d.signature = sub('d')
    end    
  end
  
  def subfields(code)
    @field.subfields.select {|subf| subf.code == code}
  end
  
  def sub(code, separator=nil, skip_first_separator=false)
    result = ""
    subfields(code).each do |subf|
      result += separator if separator && !(result.empty? && skip_first_separator)
      result += subf.data 
    end
    result
  end
  
  def construct_title
    sub('a') + sub('e', " : ") + sub('f', " / ") + sub('g', " ; ") + sub('c', " . ")
  end
  
  def construct_publisher
    result = sub('a', " ; ", true) + sub('c', " : ") + sub('d', ', ')
    subresult = sub('e') + sub('g', " : ") + sub('h', ", ")
    result += " (#{subresult})" unless subresult.empty?
    result 
  end
  
  def construct_physical_description
    sub('a') + sub('c', " : ") + sub('d', " ; ")    
  end
  
  def add_names(d)
    @names.each do |name|
      d.names << name
    end
  end
  
  def add_children(d)
    @children.each do |child|
      d.children << child
    end
  end
  
  def create_or_find_author(id_sbn, name)
    author = 
      Author.find_by_id_sbn(id_sbn) || 
      Author.new(:name => name, :id_sbn => id_sbn)
    author.save || (raise author.errors.full_messages.join("; "))
    author
  end
  
  def append(a, b)
    return b unless a
    "#{a}; #{b}"
  end
  
  def sub_unless_nil(code)
    sub(code) == "" ? nil : sub(code).strip
  end
  
  # nel field 413 è codificata una mini-sottoscheda
  def sub_subfields(pseudotag, codes)
    result = []
    current = nil
    @field.subfields.each do |subf|
      if "1" == subf.code && subf.data =~ pseudotag
        current = { :pseudotag => subf.data[0, 3] }
        result << current
      end
      if current
        current[subf.code] = subf.data
      end
    end
    result
  end
  
  def create_or_find_document(data)
    document = Document.find_by_id_sbn(data[:id_sbn])
    return document if document
    document = Document.new(data)
    document.save || (raise "cannot save child " + child.errors.full_messages.join(", "))
    document    
  end
  
  def create_child_document
    child = create_or_find_document(:title => subfields('a')[0].data, :id_sbn => subfields('1')[0].data)
    sub_subfields(/^7\d\d/, /3|a|e/).each do |ssf|
      author = create_or_find_author(ssf['3'], ssf['e'] || ssf['a'])
      if '700' == ssf[:pseudotag]
        child.author = author
      end
      child.names << author
    end
    @children << child
  end
end
