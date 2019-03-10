
begin
def swap!(a,b) 
	a,b=b,a 
	print a 
	print b 
end
a=1 
b=2
swap! a,b 
print a, b 
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"