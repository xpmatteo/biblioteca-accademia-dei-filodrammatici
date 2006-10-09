include Unimarc

class Document < ActiveRecord::Base
  
  has_many :marc_fields, :order => "tag"
  belongs_to :author
  
  def self.import_unimarc(filename)
    Unimarc::do_import(filename)
  end
  
  def publication
    place_of_publication + ": " + publisher + ", " + date_of_publication[0..3]
  end
  
  # def title
  #   marc_fields.find_by_tag('200').join(" / ")
  # end
end
