
begin
#!/usr/bin/ruby 
require 'gtk2'  
class RubyApp < Gtk::Window  
	def initialize   
		 #init_ui  
		 #show_all 
		 end 
=begin
		   def init_ui   

		  fixed = Gtk::Fixed.new 

		   add fixed   

		  button = Gtk::Button.new "Quit" 

		   button.set_size_request 80, 35  

		   button.signal_connect "clicked" do

		      Gtk.main_quit   

		  end  

		   fixed.put button, 50, 50  

		   set_default_size 250, 200    set_window_position Gtk::Window::POS_CENTER  
		end=end
end   
		    Gtk.init  
		   window = RubyApp.new 
		   Gtk.main


rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"