class CreateTeachers < ActiveRecord::Migration
  def self.up
    create_table :teachers do |t|
      # t.column :name, :string
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :course_name, :string
      t.column :curriculum, :text
      t.column :for_seminar, :boolean
      t.column :image, :string
    end
  end

  def self.down
    drop_table :teachers
  end
end
