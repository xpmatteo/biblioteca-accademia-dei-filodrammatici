class Content < ActiveRecord::Base
  
  validates_uniqueness_of :name
  validates_presence_of :title, :name, :body
  
  def full_image_url
    "/images/" + image_url
  end
end
