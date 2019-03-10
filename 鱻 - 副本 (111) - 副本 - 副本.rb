
begin
s1="h\nh"
File.open("cswb.ini", 'wb') { |file| file.write(s1)  }



rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"