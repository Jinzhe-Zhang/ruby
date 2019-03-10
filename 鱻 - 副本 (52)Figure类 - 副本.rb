	class Figure
		@@name=0
attr_accessor :nam
attr_accessor :hp
attr_accessor :mp
attr_accessor :atk
attr_accessor :spd
attr_accessor :spe
attr_accessor :spety
attr_accessor :xdz
attr_accessor :pic
def initialize(n="figure"<<@@name.to_s,h=5,a=1,s=5,specialtype=0,special=0,m=0)
@nam =n
@hp=h
@mp=m
@atk=a
@spd=s
@spe=special
@spety=specialtype
@xdz=0
@pic=TkPhotoImage.new
end
def Figure.Battle(*ff)
	f=ff.map { |e|e.dup  }
	m=Array.new
	loop { 
		f.each { |e|
			e.xdz+=e.spd
			if e.xdz>=Length_of_bar
				m<<e
			end  }
			if m.length>0
				n=0
				while n<m.length
					q=m[0]
					(m.length-n-1).times { |nn|
				print m.length
						if (m[nn+1].xdz-Length_of_bar)*q.spd>(q.xdz-Length_of_bar)*m[nn+1].spd+1e-10
							q=m[nn+1]
						end  }
						puts "\n\n\n#{q.nam}'s turn"
						puts "#{f[0].xdz}"
						puts "#{f[1].xdz}"
						puts "choose a number"
						a=f.dup
						a.delete(q)
						c=gets.to_i
						if q.hit(f[c])
							puts "#{f[c].nam}倒下了!"
							if m.include?(f[c])
								m.delete(f[c])
							end
							f.delete_at(c)
							if f.length==1
								return
							end
							n+=1
						end
					q.xdz-=Length_of_bar
					m.delete(q)
				end 
			end
		}
end
def hit(w)
	if w.spety==2
		if atk>w.spe
	sh =atk-w.spe
		else
			sh=0
		end
	else
		sh =atk
	end
	w.hp-=sh
	puts "#{w.nam} was hurt!\nhp-#{sh}\n#{w.hp} hp left"
	sleep 1
	if spety==1
		atk+=spe
	end
	w.hp<=0
end

end

class Ene < Figure
	attr_accessor :mon
	attr_accessor :ex
	@@num=0
	EnePic=TkPhotoImage.new(:file=>"1.gif")
def initialize(n="figure"<<@@name.to_s,h=5,a=1,s=5,money=[0,0,0,0,0],experience=0,specialtype=0,special=0,m=0)
super(n,h,a,s,specialtype,special,m)
@mon=money
@ex=experience
@pic.copy(EnePic,:from=>[(@@num%12)*32,@@num/12*32,(@@num%12)*32+32,@@num/12*32+32])
@@num+=1
end

end

class Hero < Figure
	@@num=0
	attr_accessor :num
	attr_accessor :lv
	attr_accessor :ex
	@@efl=Array.new(99) { |i|(5*1.2**i).to_i}
	HeroPic=TkPhotoImage.new(:file=>"1.gif")
def initialize(n="figure"<<@@name.to_s,lv=1,h=5,a=1,s=5,specialtype=0,special=0,m=0)
super(n,h,a,s,specialtype,special,m)
@ex=0
@pic.copy(HeroPic,:from=>[(@@num%12)*32,@@num/12*32,(@@num%12)*32+32,@@num/12*32+32])
@@num+=1
@num=@@num
end
end