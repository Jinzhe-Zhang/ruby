
begin
Dir.mkdir("mynewdir")






rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"