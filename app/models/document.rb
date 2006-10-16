include Unimarc

class Document < ActiveRecord::Base
  
  has_many :marc_fields, :order => "tag"
  has_many :authorships
  has_many :authors, :through => :authorships
  
  def publication
    place_of_publication + ": " + publisher + ", " + date_of_publication[0..3]
  end
  
  def date_of_publication
    marc(210, 'd')
  end
  
  def place_of_publication
    marc(210, 'a')
  end
  
  def publisher
    marc(210, 'c')
  end
  
  def title
    tit = marc_fields.find_by_tag('200').subfields.map{|sf| sf.body}.join(" / ")
    title = remove_asterisk(tit)
    title_without_article = after_asterisk(tit)
  end
  
  def language 
    expand_marc_country_code(marc('101', 'a'))
  end
  
private
  def marc(tag, code)
    field = marc_fields.find_by_tag(tag.to_s)
    return "" unless field
    subfield = field.subfields.find_by_code(code)
    return "" unless subfield
    subfield.body || ""
  end
end
