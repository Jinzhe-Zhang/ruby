
begin
	$c=0
	10.times{$a=Array.new(100000) { |i| rand(10000) }
puts"start"
t=Time.now
def range(r,rr)
	r.upto(rr-1) { |n|r.upto (rr+r-n-1){ |nn|if $a[nn]>$a[nn+1]
		$a[nn],$a[nn+1]=$a[nn+1],$a[nn]
		
	end  }  }
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