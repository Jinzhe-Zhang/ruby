
begin
	m=""
	@b||=0
loop {a=gets
if a=="\n"
 	@b+=1
 else
 	@b = 0
 end 
 m<<a
 if @b==3
 	break
 end
 }
 eval m
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"