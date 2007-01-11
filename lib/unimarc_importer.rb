require 'rmarc'

class UnimarcImporter
  
  attr_accessor :field
  
  def do_import(filename)
    reader = RMARC::MarcXmlReader.new(filename)
    while reader.has_next
      record = reader.next()
      d = Document.new      
      record.each do |field|
        @field = field
        parse_field(d)
      end
      d.save
      print "."
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
    when '210'
      d.publisher = construct_publisher
    when '215'
      d.physical_description = construct_physical_description
    when '300'
      if d.notes
        d.notes += ". " + sub('a')
      else
        d.notes = sub('a')
      end
    when '700', '701', '702', '710', '711', '712'          
      id_sbn = sub('3')
      author = 
        Author.find_by_id_sbn(id_sbn) || 
        Author.new(:name => sub('a'), :id_sbn => id_sbn)
      author.save
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
end
