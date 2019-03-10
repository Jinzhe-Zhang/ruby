
begin

require 'gtk2'  
  
=begin  
 Msgbox: an easy message box based on Gtk::MessageDialog  
 usage:  
  example 1:  
    Msgbox.new("This is a simple message box !").show  
      
  example 2:  
    if Msgbox.new("Yes or No ?", :type => :QUESTION, :buttons => :YES_NO).show  
      puts "Your answer is: 'yes'"  
    else  
      puts "Your answer is not 'yes'"  
    end  
      
  example 3:  
    Msgbox.new("OK or cancel ?", :type => :QUESTION, :buttons => :OK_CANCEL) do  
      puts "Your answer: ok"  
    end  
      
  example 4, from within Gtk::Window or subclass:  
    msgbox "Hello"  
    msgbox! "warning infomation !"  
    msgbox_err "error !"  
    msgbox? "answer the question ...", :buttons=>:YES_NO  
      
=end  
  
class Msgbox  
    
  def initialize(text = nil, param = {}, &block)  
    @param = {}  
    @param[:block] ||= block                      
    if @param[:block]  
      show(text, param)  
    else  
      set_params(text, param)  
    end  
  end  
  
  def set_params(text = nil, param = {})  
    @param[:parent] ||= param[:parent]  
    @param[:text] ||= text  
    @param[:buttons] = case param[:buttons]  
                      when :CANCEL, :cancel, "CANCEL", "cancel"  
                        Gtk::MessageDialog::BUTTONS_CANCEL  
                      when :CLOSE, :close, "CLOSE", "close"  
                        Gtk::MessageDialog::BUTTONS_CLOSE  
                      when :OK,:ok, "OK", "ok"  
                        Gtk::MessageDialog::BUTTONS_OK  
                      when :OK_CANCEL,:ok_cancel, "OK_CANCEL", "ok_cancel"  
                        Gtk::MessageDialog::BUTTONS_OK_CANCEL  
                      when :YES_NO, :yes_no, "YES_NO", "yes_no"  
                        Gtk::MessageDialog::BUTTONS_YES_NO  
                      when :NONE, :none, "NONE", "none"  
                        Gtk::MessageDialog::BUTTONS_NONE  
                      else  
                        @param[:buttons] || Gtk::MessageDialog::BUTTONS_OK  
                      end  
    @param[:flags] ||= Gtk::Dialog::MODAL  
    @param[:title] ||= param[:title]  
    @param[:type] =  case param[:type]  
                    when :ERROR  
                      @param[:title] ||= "Error"  
                      Gtk::MessageDialog::ERROR  
                    when :INFO  
                      @param[:title] ||= "Information"  
                      Gtk::MessageDialog::INFO  
                    when :QUESTION  
                      @param[:title] ||= "Question"  
                      Gtk::MessageDialog::QUESTION  
                    when :WARNING  
                      @param[:title] ||= "Warning"  
                      Gtk::MessageDialog::WARNING  
                    else  
                      @param[:title] ||= "Information"  
                      @param[:type] || Gtk::MessageDialog::INFO  
                    end  
  end    
    
  def show(text = nil, param = {}, &block)  
    set_params(text, param)  
    dialog = Gtk::MessageDialog.new(@param[:parent], @param[:flags], @param[:type], @param[:buttons], @param[:text])  
    dialog.title = @param[:title]  
    dialog.signal_connect('response') do |w, response|  
      @response = case response  
                  when Gtk::Dialog::RESPONSE_ACCEPT, Gtk::Dialog::RESPONSE_OK, Gtk::Dialog::RESPONSE_APPLY, Gtk::Dialog::RESPONSE_YES  
                    true  
                  else  
                    false  
                  end  
      dialog.destroy  
    end  
    if @param[:parent]  
      x, y = @param[:parent].position  
      w, h = @param[:parent].size  
      dw, dh = dialog.size  
      dialog.move x + (w - dw) / 2, y + (h - dh) / 2  
    end  
    dialog.run  
    @param[:block] ||= block  
    block.call if @param[:block] && @response  
    @response  
  end  
    
end  
  
class Gtk::Window  
  def msgbox(text = nil, param = {}, &block)  
    param[:parent] ||= self  
    param[:block] ||= block  
    Msgbox.new(text, param).show  
  end  
    
  def msgbox!(text = nil, param = {}, &block)  
    msgbox(text, param.merge!({:type=>:WARNING, :block=>block}))  
  end  
    
  def msgbox_err(text = nil, param = {}, &block)  
    msgbox(text, param.merge!({:type=>:ERROR, :block=>block}))  
  end  
    
  def msgbox?(text = nil, param = {}, &block)  
    msgbox(text, param.merge!({:type=>:QUESTION, :block=>block}))  
  end  
    
end  
  
  
if $0 == __FILE__  
  
class TestWin < Gtk::Window  
  def initialize  
    super("Message Box Test")  
      
    box = Gtk::HButtonBox.new  
    buts = []  
    ["Info", "Warn", "Error", "Question"].each do |t|  
      buts << (but = Gtk::Button.new(t))  
      box.pack_start but  
    end  
      
    buts[0].signal_connect("clicked") do   
      msgbox "Hello"  
    end  
      
    buts[1].signal_connect("clicked") do   
      msgbox! "Hello !"  
    end  
      
    buts[2].signal_connect("clicked") do   
      msgbox_err "Hello, Hello, Hello !!", :title=>"Error happens !"  
    end  
      
    buts[3].signal_connect("clicked") do   
      if msgbox? "Hello ?", :buttons=>:YES_NO  
        msgbox "you select 'YES'"  
      else  
        msgbox "you don't select 'YES'"  
      end  
    end  
      
    signal_connect("delete-event") do  
      Gtk.main_quit  
      false  
    end  
    add(box)      
  end   
      
end  
  
win = TestWin.new  
win.show_all  
GC.start  
Gtk.main  
end  
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"