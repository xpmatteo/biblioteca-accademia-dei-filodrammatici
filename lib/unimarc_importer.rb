require 'rmarc'

class UnimarcImporter
  
  attr_accessor :field
  attr_writer :verbose
  
  def initialize(verbose=false)
    @verbose = verbose
  end
  
  def import_xml(filename)
    do_import RMARC::MarcXmlReader.new(filename)
  end
  
  def import_binary(filename)
    do_import RMARC::MarcStreamReader.new(filename)
  end
  
  def do_import(reader)
    count = 0
    @link_manager = LinkManager.new
    while reader.has_next
      record = reader.next()
      d = Document.new      
      @names = []
      @children = []
      record.each do |field|
        @field = field
        parse_field(d)
      end
      denormalize_names(d)
      if Document.find_by_id_sbn(d.id_sbn)
        log "already have #{d.id_sbn}" 
        @children.each {|child| child.destroy }
      else
        d.save || (raise "cannot save: #{d.attributes} " + d.errors.full_messages.join(", "))
        add_names(d)
        add_children(d)
      end
      count += 1
      log count 
      $stdout.flush
    end
    log "Fixing links..."
    @link_manager.fix_links
  end
  
  def log(message)
    puts message if @verbose
  end
  
  def parse_field(d)
    case @field.tag
    when '001' 
      d.id_sbn = cleanup_id_sbn(@field.data)
    when '012' 
      d.footprint = sub('a')
    when '020'
      d.national_bibliography_number = sub('b') if sub('a') == "IT"
    when '200'
      d.title = construct_title
    when '205'
      d.physical_description = sub('a')
    when '210'
      d.publication = construct_publisher
      d.place = extract_place
      d.publisher = sub('c')
      d.year = $1 if sub('d') =~ /([12]\d{3})/
      d.century = d.year / 100 + 1 if d.year
      d.century = $1.to_i + 1 if sub('d') =~ /(1\d)(-\?|\.\.)/
    when '215'
      d.physical_description = append(d.physical_description, construct_physical_description)
    when '225'
      d.collection_name = cleanup_asterisk(sub_unless_nil('a'))
      d.collection_volume = sub_unless_nil('v')
    when '300'
      if d.notes
        d.notes += ". " + sub('a')
      else
        d.notes = sub('a')
      end
    when '423'
      create_child_document
    when '461', '463', '464'
      @link_manager.add_link(@field.tag, d.id_sbn, subfields('1').first.data)
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
  
  def extract_place
    first = subfields('a').first
    first.data.gsub(/\[|\]/, "") if first
  end
  
  def construct_title
    cleanup_asterisk(sub('a')) + sub('e', " : ") + sub('f', " / ") + sub('g', " ; ") + sub('c', " . ")
  end
  
  def construct_publisher
    result = sub('a', "; ", true) + sub('c', ": ") + sub('d', ', ')
    subresult = sub('e') + sub('g', ": ") + sub('h', ", ")
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
      child.hierarchy_type = "issued_with"
      d.children << child
    end
    d.hierarchy_type = "issued_with"
  end
  
  def create_or_find_author(id_sbn, name)
    id_sbn = cleanup_author_id_sbn(id_sbn)
    author = 
      Author.find_by_id_sbn(id_sbn) || 
      Author.new(:name => name, :id_sbn => id_sbn)
    author.save || (raise "can't save author: " + author.inspect + ": " + author.errors.full_messages.join("; "))
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
  
  def denormalize_names(document)
    document.responsibilities_denormalized = @names.map { |author| author.name }.join("; ")
  end
  
  def cleanup_id_sbn(value)
    value = $1 + $2 if value =~ /IT\\ICCU\\([^\\]+)\\([^\\]+)/
    value
  end

  def cleanup_author_id_sbn(value)
    return "C" + $1 + $2 if value =~ /IT\\ICCU\\([^\\]+)\\([^\\]+)/
    value
  end
  
  def cleanup_asterisk(str)
    return $1 + $2 if str =~ /^H(.[^I]*)I(.*)$/
    str
  end
end

class LinkManager
  
  Link = Struct.new(:tag, :from, :destination)
  
  def initialize
    @links = []
  end
  
  def add_link(tag, from, destination)
    destination = $1 if destination =~ /001(.*)/
    destination = $1 + $2 if destination =~ /IT\\ICCU\\([^\\]+)\\([^\\]+)/
    @links << Link.new(tag, from, destination)
  end

  def fix_links
    sort_links # così i link 464 vengono analizzati per ultimi e possiamo eliminare le rel circolari
    @links.each do |link|
#      p link
      setup_parent_and_child(link.destination, link.from) if "461" == link.tag
      setup_parent_and_child(link.from, link.destination) if "463" == link.tag
      setup_parent_and_child(link.from, link.destination) if "464" == link.tag
    end
  end
  
  private
  def sort_links
    @links.sort! {|a,b| a.tag <=> b.tag }
  end
  
  def setup_parent_and_child(parent_id, child_id)
    parent = Document.find_by_id_sbn(parent_id) || (puts "can't find parent #{parent_id}"; return)
    child = Document.find_by_id_sbn(child_id)   || (puts "can't find child #{child_id}"; return)    
    avoid_circular_relation(parent, child)
    child.hierarchy_type = "composition"
    parent.children << child
    parent.hierarchy_type = "composition"
    parent.save
  end
  
  def avoid_circular_relation(parent, child)
    if parent.parent == child 
      parent.parent = nil
    end
  end
end