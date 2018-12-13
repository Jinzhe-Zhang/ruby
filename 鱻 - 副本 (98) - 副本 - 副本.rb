
begin
	$c=0
	10.times{
$a=Array.new(100000) { |i| rand(10000) }
puts"start"
t=Time.now
def range(r,rr)
	if r<rr
		c=Array.new()
		d=Array.new()
		b=$a[rr]
		(r).upto(rr-1) { |n|  if $a[n]<b
			c<<$a[n]
		else
			d<<$a[n]			
		end
	}
	$a[r..rr]=(c<<b)+d
	range(r,r+c.length-2)
	range(rr-d.length+1,rr)
	end
		
	end
	
	range(0,$a.length-1)
	puts"#{g=Time.now-t}"
$c+=g}
puts "Average:#{$c/10}"










rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"