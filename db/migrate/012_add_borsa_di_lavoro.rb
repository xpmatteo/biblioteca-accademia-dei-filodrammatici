class AddBorsaDiLavoro < ActiveRecord::Migration
  def self.up
    Content.new( :title => 'Borsa di lavoro "Antonio Marietti"', :name => 'borsa-antonio-marietti', :body => 'bla bla' ).save
  end

  def self.down
    Content.delete(:conditions => "name like '/%'")
  end
end
