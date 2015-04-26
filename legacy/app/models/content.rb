class Content < ActiveRecord::Base
  
  validates_uniqueness_of :name
  validates_presence_of :title, :name, :body
  
  file_column :image, 
    :magick => { :geometry => "1000x200>" },
    :root_path => File.join(RAILS_ROOT, "public", "upload"), 
    :web_root => "upload/"
end
