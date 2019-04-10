
begin
require 'mini_magick'
img = MiniMagick::Image.open "zara.jpg"

#取得宽度和高度

w,h = img[:width],img[:height] #=> [2048, 1536]

shaved_off = ((w-h)/2).round #=> 256

img.shave "#{shaved_off}x0" #此处表示宽度上左右各截取256个像素，高度上截取0像素

img.write "2.jpg"

rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"