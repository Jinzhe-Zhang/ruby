
begin
a="::aqwerqwerq:aaa::bwer:cob"
b=Hash.new 
a.gsub!(/(::.+?:)|(:.)/) { |match| b[match[2]]=match[3..-2]
	"" 
}
puts a 
puts b 
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"