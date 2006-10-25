include Unimarc

class Document < ActiveRecord::Base
  validates_uniqueness_of :id_sbn
  validates_presence_of :id_sbn
  
  has_many :marc_fields, :order => "tag"
  
  has_many :names, 
    :class_name => "Author", 
    :finder_sql => 
      'select * from authors where id_sbn in (select subfield_3 from marc_fields where document_id = #{id} and tag like \'7%\') order by name',
    :counter_sql => 
      'select count(*) from authors where id_sbn in (select subfield_3 from marc_fields where document_id = #{id} and tag like \'7%\')'
  
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
  
  def physical_description
    marc(215, 'a') + marc(215, 'c', " : ") + marc(215, 'd', " ; ")
  end
  
  def language 
    expand_marc_country_code(marc('101', 'a'))
  end
  
  # def names
  #   Author.find(:all, 
  #     :conditions => 
  #       "id_sbn in (select subfield_3 from marc_fields where document_id = #{id} and tag like '7%')",
  #     :order => 'name'
  #     )
  # end
  
  def author
    @cached_author ||= Author.find(:first, 
                      :conditions => 
                        "id_sbn in (select subfield_3 from marc_fields where document_id = #{id} and tag = 700)")
  end
  
private

  def fields(tag)
    tag = tag.to_s
    @fields ||= marc_fields.to_a
    @fields.find { |f| f.tag == tag }
  end

  def marc(tag, code, prefix="")
    field = fields(tag)
    return "" unless field
    subfield = field.send("subfield_#{code}".to_s)
    return "" unless subfield
    prefix + subfield or ""
  end
end
