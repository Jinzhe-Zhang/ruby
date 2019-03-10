begin
	class Canva
		def initialize
			
		@s=""
		@q=Array.new(16) { Array.new(16,0) }
		end
		def draw
			system"cls"
			@s=""

			1.upto(15) { |n|1.upto(15) {|nn|@s+=(n==1||n==15) ? ((nn==1||nn==15 )? "+ ": "- "):((nn==1||nn==15) ? "| " : "+ ")  } 
			@s+="\n" }
			puts @s

		end
		def redraw
			system"cls"
			puts @s

		end
		def blackdown(x,y)
			@s[31*y+x*2-33]='@'
			redraw


		end

		def whitedown(x,y)
			@s[31*y+x*2-33]='&'
			redraw


		end
		def win?(x,y)
			1.upto(5) { |n|a=0;1.upto(5) { |nn|if (x-n+nn>0&&x-n+nn<16&&y-n+nn>0&&y-n+nn<16)
				a+=@q[x-n+nn][y-n+nn]
			end   }
			 if(a==5) 
			return true; 
		end  }
		1.upto(5) { |n|a=0;1.upto(5) { |nn|if (x>0&&x<16&&y-n+nn>0&&y-n+nn<16)
				a+=@q[x][y-n+nn]
			end   }
			 if(a==5) 
			return true; 
		end  }
		1.upto(5) { |n|a=0;1.upto(5) { |nn|if (x-n+nn>0&&x-n+nn<16&&y>0&&y<16)
				a+=@q[x-n+nn][y]
			end   }
			 if(a==5) 
			return true; 
		end  }
		1.upto(5) { |n|a=0;1.upto(5) { |nn|if (x-n+nn>0&&x-n+nn<16&&y+n-nn>0&&y+n-nn<16)
				a+=@q[x-n+nn][y+n-nn]
			end   }
			 if(a==5) 
			return true; 
		end  }
		return false

		end
		def in(c)
			a=gets.to_i
			while(a<1 || a>15)
				puts"wrong"
				a=gets.to_i
			end
			@x=a
			a=gets.to_i
			while(a<1 || a>15)
				puts"wrong"
				a=gets.to_i
			end
			@y=a
			while(@q[@x][@y]!=0)
				redraw
				puts"the place has a peace"
				a=gets.to_i
				while(a<1 || a>15)
					puts"wrong"
					a=gets.to_i
				end
				@x=a
				a=gets.to_i
				while(a<1 || a>15)
					puts"wrong"
					a=gets.to_i
				end
				@y=a
			end
			@q[@x][@y]= c ? 1:-1






		if c
			blackdown(@x,@y)
		else
			whitedown(@x,@y)

		end
if win?(@x,@y)
				print c ? '@': '&' , "win!\n"
				system"pause"
				@q=Array.new(15) { Array.new(15,0) }
					draw

				
			end
		end

	end
a=Canva.new
a.draw
loop { 
	a.in(true)
	a.in(false) 
}







rescue Exception => e
	print  e.message
end
system"pause"
