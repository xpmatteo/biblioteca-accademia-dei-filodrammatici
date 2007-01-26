class AddConstraintOnResponsibility < ActiveRecord::Migration
  def self.up
    add_index :responsibilities, [:author_id, :document_id], :unique => true
  end

  def self.down
    remove_index :responsibilities, :column => [:author_id, :document_id]
  end
end
