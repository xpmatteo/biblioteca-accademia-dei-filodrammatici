class ConvertDocumentNotesToText < ActiveRecord::Migration
  def self.up
    execute "alter table documents change notes notes text"
    execute "alter table documents change title title text"
  end

  def self.down
  end
end
