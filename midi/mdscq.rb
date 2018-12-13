begin
	$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')
#encoding=UTF-8  
require 'midilib/sequence'
require 'midilib/consts'
include MIDI
EE=[1,2,3,4,5,6,7,8,10,9,11,12,13,14,15,0]
seq = Sequence.new()
@quarter_note_length = seq.note_to_delta('quarter')
$music=Array.new {  } #音色,音调,始时,终时,音量#############################################
$musi= Array.new {  } #始终,时间,音色,音调,音量s
$time=0
$tim=0
$ti=[]
$mus=[[]]
$message=[]
$pb=[]
$cdy=Hash.new { }
def yc(t,a)
   $track[a].events << NoteOff.new(0, 0, 0, t)
end
def j (test,a)
	$time=$tim
	#print test
	test.each { |e|#print "\n\n",e,"\n\n\n"
	#	print e[0][0].class,e[0][0].class.class
		if e.length==4 && e[2].is_a?(Integer) 
				e[0].length.times { |n| 
				$music[a]<< [0,e[0][n],$time+((n+0.5-e[0].length/2)*e[3]).to_i,$time+(e[1]*@quarter_note_length).to_i,e[2]]

		}
	$time+=(e[1]*@quarter_note_length).to_i
else
					$timee=$time
					e.each { |ee| 	ee[0].length.times{ |n| 
				$music[a]<< [0,ee[0][n],$timee+((n+0.5-ee[0].length/2)*ee[3]).to_i,$timee+(ee[1]*@quarter_note_length).to_i,ee[2]]

		}
	$timee+=(ee[1]*@quarter_note_length).to_i }
				

	end
		  }
end
def com_st(a,b,e,n)
			if b-a<=1
					$musi[n].insert(a,[true,e[2],e[0],e[1],e[4]])
		
		elsif $musi[n][((a+b-2)/2).to_i][1]<=e[2]
		com_st(((a+b)/2).to_i,b,e,n)
	else
		com_st(a,((a+b)/2).to_i,e,n)
end
end
def com_en(a,b,e,n)
			if b-a<=1
					$musi[n].insert(a,[false,e[3],e[0],e[1],e[4]])
					
		
		elsif $musi[n][((a+b-2)/2).to_i][1]<e[3]
		com_en(((a+b)/2).to_i,b,e,n)
	else
		com_en(a,((a+b)/2).to_i,e,n)
end
end
def hx(i=0,type='M-',period=1,bet=0,volume=127)
	is4 =false
	case type
	when "M+"
		a=[-8,-5,0]
	when "M-"
		a=[-5,0,4]
	when 'M'
		a=[0,4,7]
	when "m+"
		a=[-9,-5,0]
	when "m-"
		a=[-5,0,3]
	when 'm'
		a=[0,3,7]
	when "M7"
		is4=true
		a=[0,4,7,11]
	when "M7-"
		is4=true
		a=[-1,0,3,7]
	when "M7+"
		is4=true
		a=[-8,-5,-1,0]
	when "M7++"
		is4=true
		a=[-5,-1,0,3]
	when "m7"
		is4=false
		a=[0,3,7,11]
	when "m7+"
		is4=true
		a=[-9,-5,-1,0]
	when "m7++"
		is4=true
		a=[-5,-1,0,3]
	when "m7-"
		is4=true
		a=[-1,0,3,7]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "M7+as"
		is4=true
		a=[0,3,7,11]
	when "MM"
		is4=false
		a=[0,4,7,12]
	end
	$track.events << NoteOn.new(0, i+a[0], volume, 0)
	if(bet!=0)
		yc(bet)
	end
	$track.events << NoteOn.new(0, i+a[1] , volume, 0)
	if(bet!=0)
		yc(bet)
	end
	$track.events << NoteOn.new(0, i+a[2] , volume, 0)
	if(bet!=0)
		yc(bet)
	end
	if is4
		$track.events << NoteOn.new(0, i+a[3] , volume, 0)
	end
$track.events << NoteOff.new(0, i +a[0], volume, period*@quarter_note_length-3*bet)
$track.events << NoteOff.new(0, i +a[0], volume, 0)
$track.events << NoteOff.new(0, i +a[1], volume, 0)
if is4
   $track.events << NoteOff.new(0, i +a[2], volume, 0)
end
end
file=Dir["*.txt"]
#print "\n\n\n",file,"\n\n\n"
if file.length==0
	puts "哎呀,你还没有任何.txt文件可以导入"#\n文件不仅可以导入,也可以写在程序里面哦!\n写一个属于你自己的音乐吧"
	system"pause"
	exit
else
	puts "输入你要读取的文件:"
	@m=[]
	str=File.read("moren.ini")
	file.each { |e| 
		@m<<e
	 print e,"\n" }
	 print "默认文件：",str,"\n"
	@e=gets
	unless (@m.include?@e.chomp!) || (@m.include?(@e<<".txt"))
		@e=str
	end
	File.open("moren.ini", 'w') { |file| file.print @e }
		@a=""
		arr = IO.readlines(@e,:encoding=>"utf-8")
		arr.each{|block|
		 if block.lstrip=="" 
		 	if @a!=""
			@u=0
		 					@a.gsub!(/[\[\]\)\{\}]/) { |match|" #{match} "}
		 					@a.gsub!(/(::[\s\S]+?:)|(:.)/) { |match| if match.length==2
		 						$cdy[match[1]]
		 						else
		 						$cdy[match[2]]=match[3..-2]
		 						""
		 					end }
			$mus[-1]<<@a
			@a=""
		else 
			$mus<<[]
		 	end
		else
			block.gsub!(/#.*$/){""}
			#print block
			@a<<block+"`"
		end }
		if @a!=""
            @u=0
                            @a.gsub!(/[\[\]\)\{\}]/) { |match|" #{match} "}
                            @a.gsub!(/(::[\s\S]+?:)|(:.)/) { |match| if match.length==2
                                $cdy[match[1]]
                                else
                                $cdy[match[2]]=match[3..-2]
                                ""
                            end }
			$mus[-1]<<@a
		end

end
$jj={ 
'a'=>60,
's'=>62,
'd'=>64,
'f'=>65,
'g'=>-1,
'h'=>-2,
'j'=>67,
'k'=>69,
'l'=>71,
';'=>72,


'q'=>72,
'w'=>74,
'e'=>76,
'r'=>77,
't'=>-3,
'y'=>-4,
'u'=>79,
'i'=>81,
'o'=>83,
'p'=>84,


'z'=>48,
'x'=>50,
'c'=>52,
'v'=>53,
'b'=>-5,
'n'=>-6,
'm'=>55,
','=>57,
'.'=>59,
'/'=>60,


'1'=>84,
'2'=>86,
'3'=>88,
'4'=>89,
'5'=>-7,
'6'=>-8,
'7'=>91,
'8'=>93,
'9'=>95,
'0'=>96,


'-'=>-9,
'='=>-10,


'A'=>61,
'S'=>63,
'D'=>-31,
'F'=>66,
'G'=>-11,
'H'=>-12,
'J'=>68,
'K'=>70,
'L'=>-32,


'Q'=>73,
'W'=>75,
'E'=>-33,
'R'=>78,
'T'=>-13,
'Y'=>-14,
'U'=>80,
'I'=>82,
'O'=>-34,
'P'=>85,


'Z'=>49,
'X'=>51,
'C'=>-35,
'V'=>54,
'B'=>-15,
'N'=>-16,
'M'=>56,
'<'=>58,
'>'=>-36,
'?'=>61,


'!'=>85,
'@'=>87,
'#'=>-37,
'$'=>90,
'%'=>-17,
'^'=>-18,
'&'=>92,
'*'=>94,
'('=>-38,
')'=>-39,


'_'=>-19,
'+'=>-20,
'['=>-21,
']'=>-22,
'\''=>-23,
'"'=>-24,
'`'=>-25,
'{'=>-26,
'}'=>-27,
':'=>-28}



def mj
	pp||=0
	$mus.each { |eee|  #e角标 
		pp+=1
		if eee==[]
			$tim=$time
			#print $tim
			if $mus[pp] !=[]
				$pb<<$music.length
			end
			next
		end
		$a||=0
		@qq||=0
	$music<<[]
		$message<<eee[0][0,6]
	eee[0]=eee[0][6..-1]
	eee.each { |e|	
	m=[]
	mm=[]
		@ts||=false
		@tss||=false
	@sd=e[0,3].to_i
	#print @sd
		@yl=100
		@dlek=@dlekk=@jq=0
		@jpp=1.0
		@slykg=false
		@pp=0
		@jpjsq=0
		@wyll=0
		@rpn=128
		@ss=""
		#print e[3..-1]
		e[3..-1].split.each{|c| #puts c
		q=0
		@rr=1
		@p=@pp
		@r=0
		@jp=0.5
		n=[]
		jc=false
			@ss+=c.gsub(/\|/,"")+" "
			while q<c.length 

					if @yltj==true
				if c[q]=='}'
					case @kzyl.length
					when 0
					when 1
						16.times { |n| 
						mm<<[[202],@kzyl[0].to_f/2048,127*n/16,0] }
					when 2
						16.times { |n|
						mm<<[[202],@kzyl[0].to_f/2048,@kzyl[1]*n/16,0]  }
					else
						(@kzyl.length-2).times{ |nn|
							16.times{ |n|
								mm<<[[202],@kzyl[0].to_f/(2048*(@kzyl.length-2)),(@kzyl[1+nn]*(16-n)+@kzyl[2+nn]*n)/16,0]
							}
						}
					end
					#print @kzyl,"\n\n",mm,"\n\n"
					@tss=true
				else
					if @kzyl==[]
						@kzyl<<c[q..q+4].to_i
					#print @kzyl,"\n\n",mm,"\n\n"
					q+=5

				else 
					@kzyl<<c[q..q+2].to_i
					q+=3
					end
					
					next
				end
			end
			@yltj=false
			@kzyl=[]
			if $jj[c[q]]>0 
				n<<$jj[c[q]]+@sd
					jc=true

			else

				case $jj[c[q]]
				when -1			#g加半拍
					@jp+=0.5
					jc=true
				when -2			#h减为一半
					@jp/=2
					jc=true
				when -13		#T三连音开关
					if @slykg
					@jpp*=1.5
					@slykg=false
					else
					@jpp/=1.5
					@slykg=true
					end
				when -12
					@jpp/=2
				when -11
					@jpp*=2
				when -3			#t增加一倍
					@jp*=2
					jc=true
				when -4			#y琶音
					@p+=(@quarter_note_length/24).to_i
				when -14			#Y连琶音
					@pp+=(@quarter_note_length/24).to_i
					@p+=(@quarter_note_length/24).to_i
				when -5			#b减弱音量
					@yl-=8
				when -7			#5增加音量
					@yl+=8
				when -8			#6升调
					@sd+=1
				when -6			#n降调
					@sd-=1
				when -15		#B渐弱
					@jq-=1
				when -17		#%渐强
					@jq+=1
				when -16			#N大降调
					@sd-=12
				when -18			#^大升调
					@sd+=12
				when -23		#'断点
					@dlek+=1
				when -24		#"断点
					@dlek-=1
				when -32		#L连续
					@dlekk,@dlek=@dlek,@dlekk
				when -21		#[]同时 sdf [mggg ] sd
					@ts=true
					#print "ts=true\n"
				when -22
					@tss=true
				when -31	#D
					if @ts
						mm<<[[201],0,c[q+1..q+3].to_i,0]
					else
						m<<[[201],0,c[q+1..q+3].to_i,0]
					end
					q+=3
				when -33		#E
					if @ts
						mm<<[[200],0,c[q+1..q+3].to_i,0]
					else
						m<<[[200],0,c[q+1..q+3].to_i,0]
					end
					q+=3
				when -35	#C声相
					if @ts
						mm<<[[203],0,c[q+1..q+3].to_i,0]
					else
						m<<[[203],0,c[q+1..q+3].to_i,0]
					end
					q+=3
				when -36	#>
					if $jj[c[q+1]]==-36
						@rr+=1
					else
					if @ts
						mm<<[[$jj[c[q+1]]],@rr.to_f/24,@yl,0]
					else
						m<<[[$jj[c[q+1]]],@rr.to_f/24,@yl,0]
					end
					q+=1
					@r+=@rr# 断音的时长	
					@rr=1
					end
				when -34
					if @ts
						mm<<[[202],0,c[q+1..q+3].to_i,0]
					else
						m<<[[202],0,c[q+1..q+3].to_i,0]
					end
					q+=3
				when -38	#弯音轮
					@wy=true
					if c[q+1]!=nil
						@rpn=c[q+1..q+5].to_i
						print(@rpn,"#############################################################################}")
					mm<<[[205],0,@rpn,0]
					end
					break
				when -39
					m<<mm
					mm=[]
					@wy=false
					@wyll=0
					break
				when -26
					@yltj=true
					@ts=true

				when -25
					@jpjsq=@jpjsq.round(3) 
					if @jpjsq%4!=0 && @jpjsq!=2
					print @jpjsq,"!!!!!   ",@ss,"\n"
				else
					puts @jpjsq
					end
					@jpjsq=0
					@ss=""
				end



				
			end
			q+=1
			
			end
			@yl+=(@jq*@jp*2).to_i
					#print "##",m,"haha\n",@ts
					if jc
						if @wy
							
							if n==[] || @wyll==(a=n[0]-@sd-60)
								mm<<[[],@jp*@jpp,0,0]
							else
								print a,"haha"
							32.times{ |nn|
								mm<<[[204],@jp*@jpp/32,8192+(@wyll*(32-nn)+a*nn)*16382/(@rpn),0]
							}
							@wyll=a
							end
							next
						end
									if @ts
			if @dlek!=0
	if @dlek+@r*1.5>@jp*@jpp*14
mm<<[n,@jp*@jpp/8-@r.to_f/24,@yl,@p]
mm<<[[],@jp*0.875*@jpp,0,0]
	else
mm<<[n,@jp*@jpp-@dlek*0.0625-@r.to_f/24,@yl,@p]
mm<<[[],@dlek*0.0625,0,0]
end
else

mm<<[n,@jp*@jpp-@dlek*0.0625-@r.to_f/24,@yl,@p]
end
			else
				#print "hehe\n\n"
				if @dlek!=0
	if @dlek+@r>@jp*@jpp*14
m<<[n,@jp*@jpp/8-@r.to_f/24,@yl,@p]
m<<[[],@jp*@jpp*0.875,0,0]
	else
m<<[n,@jp*@jpp-@dlek*0.0625-@r.to_f/24,@yl,@p]
m<<[[],@dlek*0.0625,0,0]
end
else

m<<[n,@jp*@jpp-@dlek*0.0625-@r.to_f/24,@yl,@p]
end
			end
		@jpjsq+=@jp*@jpp
					end

if @tss
	@ts=false
	#print "##",m,"haha\n"
	#print "**",mm,"\n"
	m<<mm
	mm=[]
	@tss=false
end
#print m,"asdf"
}
j(m,@qq)
	  }
@qq+=1
}
end
mj
#print $music,"  213123123123"


$time=0
$music.each { |q|$c||=0
	$musi<<[] 
	 q.length.times { |n|  
com_st(0,n*2+1,q[n],$c)
com_en(0,n*2+2,q[n],$c)
 } 
 $c+=1 }
$track=[]
ee||=0
eet||=0  #track[eet]
yjs =0  #音节数
#print $pb,"\n"
#print $musi,"\n"
$musi.length.times { |eetx|
if $pb.include? (eetx)
	#print "include",eetx
	eet = 0
	ee = 0
end
if eet>=yjs
	$track << Track.new(seq)
#print "$track[#{eet}].events << MetaEvent.new(META_SEQ_NAME, \"music track#{ee}\") "
seq.tracks << $track[eet]
yjs+=1
$ti<<0
end
$track[eet==0 ? 0 : eet-1].events << Tempo.new(Tempo.bpm_to_mpq($message[eetx][3,3].to_i))#
#print "$track[",eet,"].events << Tempo.new(Tempo.bpm_to_mpq(",$message[eetx][3,3].to_i,"))"
###########节拍
if ($message[eetx][0,3].to_i==0) ##打击乐器
eee =9
else
	eee=ee;
	  ee=EE[ee]
	$track[eet].events << ProgramChange.new(eee, $message[eetx][0,3].to_i-1)###############音色

end
	w=Array.new(120) {[0,0]}
$musi[eetx].each { |e|
	if e[3]==200
		if e[0]
			$track[eet].events << ProgramChange.new(eee,e[4]-1)
		end
	elsif e[3]==201
		if e[0]
			$track[eet].events << Tempo.new(Tempo.bpm_to_mpq(e[4].to_i))
			#print "$track[",eet,"].events << Tempo.new(Tempo.bpm_to_mpq(",e[4].to_i,"))"
		end
	elsif e[3]==202
		if e[0]
			$track[eet].events << Controller.new(eee,7,e[4], e[1]-$time-$ti[eet])
	$ti[eet]=0
$time=e[1]
		end
	elsif e[3]==203
		if e[0]
			$track[eet].events << Controller.new(eee,10,e[4])
		end
	elsif e[3]==204
		if e[0]
			$track[eet].events << PitchBend.new(eee,e[4], e[1]-$time-$ti[eet])
	$ti[eet]=0
$time=e[1]
		end
	elsif e[3]==205
		if e[0]
            $track[eet].events << Controller.new(eee,100,0,0)
            $track[eet].events << Controller.new(eee,101,0,0)
            $track[eet].events << Controller.new(eee,6,e[4]/128,0)
            $track[eet].events << Controller.new(eee,38,e[4]%128,0)
		end
			
			
	else
			




	if e[0]
w[e[3]][0]+=1
		if w[e[3]][0]==1
			$track[eet].events << NoteOn.new(eee, e[3],e[4], e[1]-$time-$ti[eet])
#print $ti[eet],"  "
	$ti[eet]=0
=begin
			print "$track[ee].events << NoteOn.new(",eee,"," ,e[3],"," ,e[4],", ",e[1]-$time,")\n"
print "w[",e[3],"][0]=",w[e[3]][0],"\n"
=end
else
$track[eet].events << NoteOff.new(eee, e[3], w[e[3]][1], e[1]-$time-$ti[eet])
$track[eet].events << NoteOn.new(eee, e[3], e[4], 0)
#print $ti[eet],"  "
	$ti[eet]=0
=begin
	print "$track[ee].events << NoteOff.new(",eee,"," ,e[3],"," ,w[e[3]][1],", ",e[1]-$time,")\n"
		print "$track[ee].events << NoteOn.new(",eee,"," ,e[3],"," ,e[4],", ",0,")\n"
		print "w[",e[3],"][0]=",w[e[3]][0],"\n"
=end
		end
	
w[e[3]][1]=e[4]
$time=e[1]
	else
	w[e[3]][0]-=1
	if w[e[3]][0]<1
	$track[eet].events << NoteOff.new(eee, e[3], e[4], e[1]-$time-$ti[eet])
	#print $ti[eet],"  "
	$ti[eet]=0
=begin
	print "$track[ee].events << NoteOff.new(",eee,"," ,e[3],"," ,e[4],", ",e[1]-$time,")\n"
		print "w[",e[3],"][0]=",w[e[3]][0],"\n"
=end
$time=e[1]
	end
	end
end
	  }
	$ti[eet]=$musi[eetx][-1][1]
	  $time=0
	  #print ee,"::",EE[ee],"\n"
	  #print ee
	eet+=1}
	#print $ti
	if Time.new < Time.local(2018,2,1)
File.open(@e[0..-5]+".mid", 'wb') { |file| seq.write(file) }
else
	puts "软件到期"
end
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
system "pause"
end