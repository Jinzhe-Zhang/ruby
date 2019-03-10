
begin
print rand(111)





rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"