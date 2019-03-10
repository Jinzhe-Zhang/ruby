require "tk"
begin
root = TkRoot.new() { title "Today's Date" }
str = Time.now.strftime("Today is \n%B %d, %Y")
image = TkPhotoImage.new
image.file = "d.gif"
image2 = TkPhotoImage.new
image2.file = "圣灵古堡.gif"
lab = TkLabel.new(root) do
        pack("padx" => 150, "pady" => 100,
             "side" => "top")

      end
      t1=Thread.new{
      	loop{sleep(2.9)
      		lab.image = image
      	}
      	
      }
        t2=Thread.new{
      	loop{sleep(3)
      		lab.image = image2
      	}
      	t1.join
      	t2.join
      }

Tk.mainloop
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"