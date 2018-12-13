
begin
require "Win32API"
print screen.width


rescue Exception => e
	puts e.backtrace.inspect
	puts e.message

end
system "pause"