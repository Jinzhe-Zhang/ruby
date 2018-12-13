require "tk"
begin
root = TkRoot.new() { title "move" }
cv=TkLabel.new(root)
cv2=TkLabel.new(root)
cv2.place('y'=>200,'width'=>400,
	'height'=>200)
str = Time.now.strftime("Today is \n%B %d, %Y")
iMage = TkPhotoImage.new
iMage.file = "未命名.gif"
iMage2=TkPhotoImage.new
iMage2.file ="bg.gif"
image=Array.new(3) {|i|TkPhotoImage.new.copy(iMage,:from=>[i*32,0,i*32+32,32]) }
cv.place('width'=>400,
	'height'=>200)
cv.image=TkPhotoImage.new
xt=TkProgressbar.new(root)
xt.place('width'=>32,
  'height'=>10,
  'y'=>40)
variable=TkVariable.new
xt.variable=variable
variable.value=50
xt.maximum=100
cv.image=iMage2
        

  

Tk.mainloop
rescue Exception => e
      puts e.backtrace.inspect
      puts e.message
end
system "pause"