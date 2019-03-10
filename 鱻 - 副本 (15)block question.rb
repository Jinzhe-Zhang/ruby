
begin
	100000.times{$b=0
	$map=Array.new(11) { |n|Array.new(11){|nn|
		n==1||nn==1? false : true
	}  }
	def pr
		1.upto(9) { |n|1.upto(9) { |nn| print $map[n][nn]? "1": "0" } 
		puts "\n" ;}
	end
 1000.times{
 	x=rand(9)+1
 	y=rand(9)+1

 	if $map[x][y]&&$map[x][y-1]&&$map[x][y+1]&&$map[x-1][y]&&!$map[x+1][y]||$map[x][y]&&$map[x][y-1]&&$map[x][y+1]&&!$map[x-1][y]&&$map[x+1][y]||$map[x][y]&&!$map[x][y-1]&&$map[x][y+1]&&$map[x-1][y]&&$map[x+1][y]||$map[x][y]&&$map[x][y-1]&&!$map[x][y+1]&&$map[x-1][y]&&$map[x+1][y]
 		$map[x][y]=false
 		$b+=1
 	end
 }
 1.upto(9) { |x|1.upto(9) { |y| 	
 	if $map[x][y]&&$map[x][y-1]&&$map[x][y+1]&&$map[x-1][y]&&!$map[x+1][y]||$map[x][y]&&$map[x][y-1]&&$map[x][y+1]&&!$map[x-1][y]&&$map[x+1][y]||$map[x][y]&&!$map[x][y-1]&&$map[x][y+1]&&$map[x-1][y]&&$map[x+1][y]||$map[x][y]&&$map[x][y-1]&&!$map[x][y+1]&&$map[x-1][y]&&$map[x+1][y]
 		$map[x][y]=false
 		$b+=1
 	end }  }
if $b==41
	puts "#{$b}"
	pr
end

}
	





rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"