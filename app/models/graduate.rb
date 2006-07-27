class Graduate < ActiveRecord::Base                                                     
  
  def self.graduation_years
    self.find_by_sql('select distinct graduation_year from graduates order by graduation_year').map do |g|
      g.graduation_year
    end
  end
  
  def self.initials     
    sql = 'select distinct upper(left(last_name, 1)) as initial from graduates order by last_name'
    self.find_by_sql(sql).map do |g|
      g.initial
    end
  end
end
