class Teacher < ActiveRecord::Base

  validates_presence_of :first_name, :last_name
  
  file_column :image, 
    :magick => { :geometry => "400x400>" },
    :root_path => File.join(RAILS_ROOT, "public", "upload"), 
    :web_root => "upload/"

  def name
    first_name + ' ' + last_name.upcase
  end
end
