
# def add_author_to_names(a)
#   Document.find(:all, :conditions => "author_id = #{a.id}").each do |d|
#     unless d.names.member?(a)
#       d.names << a
#     end
#   end  
# end

#puts `mysql filo_development < db/local-stage2.sql`
puts "Authors before: #{Author.count}"

count = 0
Author.find(:all).each do |a|
  puts count if count % 100 == 0
  count += 1
  
  add_author_to_names(a)
  if a.documents.size == 0
    puts "deleting #{a.attributes.inspect}"
    a.destroy
  end
end
puts "Authors after: #{Author.count}"
