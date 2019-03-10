begin
	$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')
require 'midilib/sequence'
require 'midilib/consts'
include MIDI
seq = Sequence.new()
$track = Track.new(seq)
seq.tracks << $track
$track.events << Tempo.new(Tempo.bpm_to_mpq(110))
$track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')
@quarter_note_length = seq.note_to_delta('quarter')
print @quarter_note_length
$music=Array.new(0) { |i|Array.new(5) { |i|  }  }#音色,音调,始时,终时,音量
$musi=Array.new(0) { |i| Array.new(5) { |i|  } }#始终,时间,音色,音调,音量
$time=0
$mus=[]
def yc(t)
   $track.events << NoteOff.new(0, 0, 0, t)
end
def j (test)
	$time=0
	test.each { |e|
		e[0].length.times { |n| 
			$music<< [0,e[0][n],$time+(n+1-e[0].length)*e[3],$time+(e[1]*@quarter_note_length).to_i,e[2]]
		}
	$time+=(e[1]*@quarter_note_length).to_i
		  }
end
def com_st(a,b,e)
			if b-a<=1
					$musi.insert(a,[true,e[2],e[0],e[1],e[4]])
					
		
		elsif $musi[((a+b-2)/2).to_i][1]<=e[2]
		com_st(((a+b)/2).to_i,b,e)
	else
		com_st(a,((a+b)/2).to_i,e)
end
end
def com_en(a,b,e)
			if b-a<=1
					$musi.insert(a,[false,e[3],e[0],e[1],e[4]])
					
		
		elsif $musi[((a+b-2)/2).to_i][1]<e[3]
		com_en(((a+b)/2).to_i,b,e)
	else
		com_en(a,((a+b)/2).to_i,e)
end
end

file=Dir["*.txt"]

if file.length==0
	puts "哎呀,你还没有任何.txt文件可以导入\n文件不仅可以导入,也可以写在程序里面哦!\n写一个属于你自己的音乐吧\n(输入help以获得帮助)"
else
	puts "输入你要读取的文件:(默认Blossom of women)"
	@m=[]
	file.each { |e| 
		@m<<e
	 print e,"\n" }
	@e=gets
	@e=(@e=="\n" ? "Blossom of women" : @e)
	if (@m.include?@e.chomp!) || (@m.include?(@e<<".txt"))
		@a=""
		arr = IO.readlines(@e)
		arr.each{|block|
		 if block.lstrip=="" && @a!=""
			$mus<<@a
			@a=""
		else
			@a<<block
			print @a
		end }
		if @a!=""
			$mus<<@a
		end
	end
end
$jj={ 
'a'=>64,
's'=>66,
'd'=>68,
'f'=>69,
'g'=>-1,
'h'=>-2,
'j'=>71,
'k'=>73,
'l'=>75,
';'=>76,


'q'=>76,
'w'=>78,
'e'=>80,
'r'=>81,
't'=>-3,
'y'=>-4,
'u'=>83,
'i'=>85,
'o'=>87,
'p'=>88,


'z'=>52,
'x'=>54,
'c'=>56,
'v'=>57,
'b'=>-5,
'n'=>-6,
'm'=>59,
','=>61,
'.'=>63,
'/'=>64,


'1'=>88,
'2'=>90,
'3'=>92,
'4'=>93,
'5'=>-7,
'6'=>-8,
'7'=>95,
'8'=>97,
'9'=>99,
'0'=>100,


'-'=>-9,
'='=>-10,


'A'=>65,
'S'=>67,
'D'=>69,
'F'=>70,
'G'=>-11,
'H'=>-12,
'J'=>72,
'K'=>74,
'L'=>76,
':'=>77,


'Q'=>77,
'W'=>79,
'E'=>81,
'R'=>82,
'T'=>-13,
'Y'=>-14,
'U'=>84,
'I'=>86,
'O'=>88,
'P'=>89,


'Z'=>53,
'X'=>55,
'C'=>57,
'V'=>58,
'B'=>-15,
'N'=>-16,
'M'=>60,
'<'=>62,
'>'=>64,
'?'=>65,


'!'=>89,
'@'=>91,
'#'=>93,
'$'=>94,
'%'=>-17,
'^'=>-18,
'&'=>96,
'*'=>98,
'('=>100,
')'=>101,


'_'=>-19,
'+'=>-20,
'['=>-21}



def mj

	$mus.each { |e|	
	m=[]
	@sd=e[0,3].to_i
		@yl=63
		@jq=0
		e[3..-1].split.each{|c|
		@p=0
		@jp=0.5
		q=0
		n=[]
			while q<c.length 

			if $jj[c[q]]>0 
				n<<$jj[c[q]]+@sd
			else
				case $jj[c[q]]
				when -1
					@jp+=0.5
				when -2
					@jp/=2
				when -3
					@jp*=2
				when -4
					@p+=(@quarter_note_length/12).to_i
				when -5
					@yl-=8
				when -7
					@yl+=8
				when -8
					@sd+=24
				when -6
					@sd-=24
				when -15
					@jq-=1
				when -17
					@jq+=1
				end
				
			end
			q+=1
			
			end
			print @yl,@jq*@jp*2," "
			@yl+=(@jq*@jp*2).to_i
m<<[n,@jp,@yl,@p]

}
j(m)
	  }

	



end
mj


$time=0
$music.length.times { |n|  
com_st(0,n*2+1,$music[n])
com_en(0,n*2+2,$music[n])
 } 


$musi.each { |e|
	if e[0]
		yc(e[1]-$time)
	$track.events << NoteOn.new(0, e[3],e[4], 0)
else
	$track.events << NoteOff.new(0, e[3], e[4], e[1]-$time)
end
$time=e[1]
	  }
File.open(@e[0..-5]+".mid", 'wb') { |file| seq.write(file) }

rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"