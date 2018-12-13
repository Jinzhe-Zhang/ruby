require "tk"
begin
root = TkRoot.new() { title "Today's Date" }
str = Time.now.strftime("Today is \n%B %d, %Y")
image = TkPhotoImage.new
image.file = "d.gif"
image2 = TkPhotoImage.new
image2.file = "圣灵古堡.gif"
lab = TkLabel.new(root) do
        pack("padx" => 150)
      end
      print lab.padx
      t1=Thread.new{@x||=160
      	loop{sleep(0.1)
      		lab.image = image
      		 	lab.place('x'=>@x) 
      		 @x+=1
      		 sleep(0.1)
      		lab.image = image2
      		lab.place('x'=>@x) 
      		 @x+=1

      		 print lab.padx
      	}
      }
        

Tk.mainloop
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"