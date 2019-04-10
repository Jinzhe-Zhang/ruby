
begin
print [11,12,13,14].index 13





rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"