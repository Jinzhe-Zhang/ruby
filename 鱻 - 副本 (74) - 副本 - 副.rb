
begin
i = 1.0
i/=5
i = i+i+i+i+i
if i==1
print i
end



rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"