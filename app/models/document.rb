include Unimarc

class Document < ActiveRecord::Base
  
  belongs_to :author
  
  def self.import_unimarc(filename)
    Unimarc::do_import(filename)
  end
end
