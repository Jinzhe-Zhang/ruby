
begin
print /[0-9]+?\.[0-9]{2}/ =~"234.23"
"234.23".gsub(/[0-9]+?\.[0-9]{2}/) { |match|  puts match}
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"