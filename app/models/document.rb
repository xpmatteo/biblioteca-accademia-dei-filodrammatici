
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
  
  # def names
  #   Author.find(:all, 
  #     :conditions => 
  #       "id_sbn in (select subfield_3 from marc_fields where document_id = #{id} and tag like '7%')",
  #     :order => 'name'
  #     )
  # end
  
  def author
    @cached_author ||= Author.find(
      :first, 
      :conditions => 
        "id_sbn in (select subfield_3 from marc_fields where document_id = #{id} and tag = 700)")
  end
  
  def Document.find_by_keywords(keywords)
    columns = %w(a b c d e f g).map {|x| "F.subfield_#{x}"}.join(", ")    
    sql = "select distinct D.* 
             from documents D
             join marc_fields F on D.id = F.document_id
            where match (#{columns}) against (?)"
    Document.find_by_sql([sql, keywords])
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
