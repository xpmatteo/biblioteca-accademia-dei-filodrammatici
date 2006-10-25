class FullText < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE marc_fields TYPE = MYISAM"
    columns = %w(a b c d e f g).map {|x| "subfield_#{x}"}.join(", ")
    execute "CREATE FULLTEXT INDEX fullt ON marc_fields (#{columns})"
  end

  def self.down
    execute "DROP INDEX fullt ON marc_fields"
    execute "ALTER TABLE marc_fields TYPE = INNODB"
  end
end
