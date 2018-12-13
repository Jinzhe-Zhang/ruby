require "tk"
begin
root = TkRoot.new() { title "Today's Date" }
str = Time.now.strftime("Today is \n%B %d, %Y")
image = TkPhotoImage.new
image.file = "1.gif"
image2 = TkPhotoImage.new
image2.file = "1.gif"

lab = TkLabel.new(root) 
      t1=Thread.new{@y||=60
      	lab.image = image
      	lab.width =lab.height =32
      	lab.place('x'=>80)
            loop{
                  
                 	lab.image = image
                  lab.image.height =32
                  lab.image.width =96
                        lab.place('y'=>@y) 
                   @y+=1
                   sleep(0.1)
                     	lab.image = image
                  lab.image.height =32
                  lab.image.width =160
                        lab.place('y'=>@y) 
                   @y+=1
                   sleep(0.1)
                     	lab.image = image
                  lab.image.height =32
                  lab.image.width =96
                        lab.place('y'=>@y) 
                   @y+=1
                   sleep(0.1) 
                     	lab.image = image  
                  lab.image.height =32
                  lab.image.width =32
                        lab.place('y'=>@y) 
                   @y+=1
                   sleep(0.1)
                   image = TkPhotoImage.new 
                   image.file ="1.gif"
            }
      }
        

Tk.mainloop
rescue Exception => e
      puts e.backtrace.inspect
      puts e.message
end
system "pause"