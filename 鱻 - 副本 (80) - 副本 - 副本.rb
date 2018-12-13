
begin
require 'gtk2'

button = Gtk::Button.new("Hello World!")
button.signal_connect("clicked") {
  puts "Hello World!"
}#!!!!!!!!!!!!!!!!!!!

window = Gtk::Window.new("Example")
window.signal_connect("delete_event") {
  puts "delete event occurred"
  #true
  false
}

window.signal_connect("destroy") {
  puts "destroy event occurred"
  Gtk.main_quit
}

window.border_width = 50
window.add(button)
window.show()

Gtk.main




rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"