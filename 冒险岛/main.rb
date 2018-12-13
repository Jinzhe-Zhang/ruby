
begin
    $LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')
require_relative 'visible.rb'
win = TestWin.new  

win.signal_connect('delete-event') do
  Gtk.main_quit
end
win.show_all  
#GC.start  
Gtk.main  
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
system "pause"
end