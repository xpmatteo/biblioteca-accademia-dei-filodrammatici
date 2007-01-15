#!/usr/bin/env ruby
require "rmarc"

reader = RMARC::MarcStreamReader.new("p6470870.LO14451.uni")
#reader = RMARC::MarcStreamReader.new("problem.txt")
doc_count = 0
writer = RMARC::MarcXmlWriter.new(File.open("out.xml", "w"))
writer.start_document
count = 0
errs = 0
while reader.has_next
    # begin
      record = reader.next()
      writer.write_record(record)
      count += 1
      if count % 1000 == 0
        writer.end_document
        doc_count += 1
        writer = RMARC::MarcXmlWriter.new(File.open("out-#{doc_count}.xml", "w"))
        writer.start_document        
      end
      STDERR.puts "OK: #{count}"
    # rescue Exception => e
    #   errs += 1
    #   STDERR.puts "ERR: #{errs}"
    # end
end
writer.end_document