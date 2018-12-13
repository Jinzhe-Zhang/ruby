require "tk"
begin
root = TkRoot.new() { title "move" }
str = Time.now.strftime("Today is \n%B %d, %Y")
iMage = TkPhotoImage.new
iMage.file = "未命名.gif"
image=Array.new(3) {|i|TkPhotoImage.new.copy(iMage,:from=>[i*32,0,i*32+32,32]) }

lab = TkLabel.new(root) 
xt=TkProgressbar.new(root)
xt.place('width'=>32,
  'height'=>10,
  'y'=>70)
variable=TkVariable.new
xt.variable=variable
variable.value=50
xt.maximum=100
      t1=Thread.new{@y||=60
      	lab.image = image[0]
      	lab.width =lab.height =32
      	lab.place('y'=>80)
            loop{
                  
                 	lab.image = image[0]
                        lab.place('x'=>@y) 
                        xt.place('x'=>@y)
                   @y+=1
                   variable.value =variable.value.to_i%100+1
                   print variable.value
                   sleep(0.1)
                     	lab.image = image[1]
                        lab.place('x'=>@y) 
                        xt.place('x'=>@y)
                   variable.value =variable.value.to_i%100+1
                   @y+=1
                   sleep(0.1)
                     	lab.image = image[2]
                        lab.place('x'=>@y) 
                        xt.place('x'=>@y)
                   variable.value =variable.value.to_i%100+1
                   @y+=1
                   sleep(0.1) 
                     	lab.image = image[1] 
                        lab.place('x'=>@y) 
                        xt.place('x'=>@y)
                   variable.value =variable.value.to_i%100+1
                   @y+=1
                   sleep(0.1)
            }
      }
        

  

Tk.mainloop
rescue Exception => e
      puts e.backtrace.inspect
      puts e.message
end
system "pause"