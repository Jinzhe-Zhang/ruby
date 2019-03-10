
begin
a = 1 
b="true" 
c="false" 
str ="  
if a==1 then  
puts '输出：#{b}'  
else  
puts '输出：#{c}'  
end  
"  
eval(str) 
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"