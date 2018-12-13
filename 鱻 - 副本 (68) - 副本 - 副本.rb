
begin
b =/[aeiou]+/.match("aaaeesdsdadsf")
print b.class,b[0],"   ",b[1],b.to_a
p b.begin(0)
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"