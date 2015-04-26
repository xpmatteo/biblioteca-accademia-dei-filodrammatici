class AddSecondImageToContent < ActiveRecord::Migration
  class Content < ActiveRecord::Base; end
  
  def self.up
    add_column :contents, :image1, :string
    dove_siamo = Content.new(:title => 'Dove Siamo', :name => 'dove-siamo', :image1 => 'map.png')
    dove_siamo.save
  end

  def self.down
    remove_column :contents, :image1
    Content.find_by_name('dove-siamo').destroy
  end
end
