class CreateGraduates < ActiveRecord::Migration
  def self.up
    create_table :graduates do |t|
      # t.column :name, :string
      # anagrafe
      t.column :first_name,       :string
      t.column :last_name,        :string
      t.column :image_url,        :string
      t.column :born_on,          :string
      t.column :fiscal_code,      :string, :limit => 16

      t.column :graduation_year,  :integer

      # riferimenti
      t.column :home_page_url,    :string
      t.column :email,            :string
      t.column :address,          :string
      t.column :phone,            :string
      t.column :fax,              :string
      t.column :mobile,           :string
      t.column :agency,           :string

      # altro
      t.column :height_cm,        :integer
      t.column :weight_kg,        :integer
      t.column :eyes,             :string
      t.column :hair,             :string
      t.column :size,             :integer
      t.column :waist,            :string
      t.column :sport,            :string
      t.column :languages,        :string
      t.column :dialects,         :string
      t.column :notes,            :string

      t.column :curriculum,       :text
    end
  end

  def self.down
    drop_table :graduates
  end
end
