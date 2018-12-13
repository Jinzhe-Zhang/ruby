
begin
require "inline"










rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"