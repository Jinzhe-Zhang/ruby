
begin
require "Win32API"
print Win32API.screen.width


rescue Exception => e
	puts e.backtrace.inspect
	puts e.message

end
system "pause"