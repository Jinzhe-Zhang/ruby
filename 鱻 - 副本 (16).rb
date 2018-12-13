
begin
	$b=0
	$map=Array.new(11) { |n|Array.new(11){|nn| if nn==10||nn==0||n==10||n==0
		false
	else
		n=1&&nn=1? false : true
	end}  }
	$map[1][1]=false
	$map[1][9]=false
	$map[9][1]=false
	$map[9][9]=false
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
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"