begin
require 'win32/sound'
include Win32
$LOAD_PATH.unshift(File.dirname(__FILE__))
Sound.play("out.wav")
rescue Exception => e
	print e.backtrace.inspect
	print e.message
end
system "pause"