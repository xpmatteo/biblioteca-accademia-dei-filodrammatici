include Unimarc

class Document < ActiveRecord::Base
  
  has_many :marc_fields, :order => "tag"
  has_many :authorships
  has_many :authors, :through => :authorships
  
  def publication
    result = marc(210, 'a') + marc(210, 'c', ": ") + marc(210, 'd', ", ")
    result += appendix = " (" + marc(210, 'e') + marc(210, 'g', ": ") + ")" unless marc(210, 'e') == ""
    result
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
    remove_asterisk marc(200, 'a') + marc(200, 'e', " : ") + marc(200, 'f', " / ")
  end
  
  def title_without_article
    after_asterisk marc(200, 'a')
  end
  
  def physical_description
    marc(215, 'a') + marc(215, 'c', " : ") + marc(215, 'd', " ; ")
  end
  
  def language 
    expand_marc_country_code(marc('101', 'a'))
  end
  
private

  def fields(tag)
    tag = tag.to_s
    @fields ||= {}
    @fields[tag] ||= marc_fields.find_by_tag(tag)
  end

  def marc(tag, code, prefix="")
    field = fields(tag)
    return "" unless field
    subfield = field.subfields.find_by_code(code)
    return "" unless subfield
    prefix + subfield.body or ""
  end
end
