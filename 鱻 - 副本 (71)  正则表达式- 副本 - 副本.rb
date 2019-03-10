
begin
def quick_sort(a)  
  (x=a.pop) ? quick_sort(a.select{|i| i <= x}) + [x] + quick_sort(a.select{|i| i > x}) : []  
end  

$a=Array.new(1000) { |i| rand(10000) }

print quick_sort $a


rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"