
begin

require 'nokogiri'
require 'xmlrpc/server'
class MyHandler  
	def func1   
		i=0    
		while i<=2     
			puts i       
			puts "func1 at: #{Time.now}"     
			sleep(2)      
			i=i+1    
		end 
	end 
	def func2    
		j=0  

		while j<=2    
			puts j     
			puts "func2 at: #{Time.now}"    
			sleep(1)      
			j=j+1   
		end
	end 
	def sumAndDifference(a, b)  
		puts @good="oooo"  
		puts b=a*b  
                    #{ "sum" => a + b, "difference" => a - b ,"@good" =>@good} 
                    return (b.to_s+"<##>"+a.to_s+"<##>"+good("1314")) 
                end 
                def sumAndDifference1(a, b)  
                	puts "Started At #{Time.now}"   
                	name=""  
                	t1=Thread.new{func1()}  
                	t2=Thread.new{func2()} 
                	t3=Thread.new{name=sumAndDifference(a,b)}  
                	t1.join   
                	t2.join   
                	t3.join  
                	puts "End at #{Time.now}"  
                	puts "name="+name.to_s


rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"