

begin
require "gtk2"

Gtk.main
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"