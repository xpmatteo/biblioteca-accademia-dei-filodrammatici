require 'rmarc'

class UnimarcImporter
  
  attr_accessor :field
  
  def do_import(filename)
    count = 0
    reader = RMARC::MarcXmlReader.new(filename)
    while reader.has_next
      record = reader.next()
      d = Document.new      
      @names = []
      record.each do |field|
        @field = field
        parse_field(d)
      end
      d.save || (raise "cannot save: " + d.errors.full_messages.join(", "))
      add_names(d)
      count += 1
      puts count
      $stdout.flush
    end
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
    when '700', '701', '702', '710', '711', '712'
      author = create_or_find_author
      @names << author
      d.author = author if '700' == @field.tag
    when '950'
      d.signature = sub('d')
    end    
  end
  
  def sub(code, separator=nil, skip_first_separator=false)
    result = ""
    @field.subfields.select {|subf| subf.code == code}.each do |subf|
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
  
  def create_or_find_author
    id_sbn = sub('3')
    author = 
      Author.find_by_id_sbn(id_sbn) || 
      Author.new(:name => sub('a'), :id_sbn => id_sbn)
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
end
