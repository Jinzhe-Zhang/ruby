
begin
require "nokogiri"
require 'open-uri'
doc = Nokogiri::HTML(open("http://www.runoob.com/"))
puts doc

rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"