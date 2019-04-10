
begin
require 'Win32/sound'
include Win32

Sound.beep(300,5000)
Sound.play(File.dirname(__FILE__) + '../out.wav')



rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"