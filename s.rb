 #!/usr/bin/ruby
 $bo=""
 $b=Array.new(16) { Array.new(16) { 0}  }
 begin
  class Draw
    def win?(x,y)

      return false








    end 
    def board
      $bo=""
      (1..15).each { |e|(1..15).each { |ee|$bo+=((ee==1||ee==15) ? (e==1||e==15 ? "+": "|"):(e==1||e==15 ? "-" : "+"))
       $bo+=(ee==15? "\n":" ")  }  }
       puts $bo
       
     end
     def redraw
      system"cls"
      puts $bo
    end
    def downblack(x,y)
      $bo[30*y+x*2-32]="&"
    end
    def downwhite(x,y)
      $bo[30*y+x*2-32]="@"
    end

    def gett
      loop {@s=gets
        if(@s.to_i==0)
          puts "please input an Integer"
        elsif (@s.to_i<1||@s.to_i>15)
          puts"please input an 1~15 Integer"
        else
         return @s.to_i
         break
       end}


     end
     def get(d)
      loop{x=gett
        y=gett
        if $b[x][y]!=0
          puts"the position already has a piece! please choose another place."
        else 
          break
        end}



        (!d)?downwhite(x,y):downblack(x,y)
        a.redraw()

      end

    end
    class Dot
      attr_reader :x, :y
      def set(xx,yy)
        x=xx
        y=yy
      end
    end
    a=Draw.new
    a.board()
    loop{
     a. get(true) 
     a.get(false)
   }

























 rescue Exception => e
   puts e.backtrace.inspect
   puts
   puts e.message
   puts

 end




 system("Pause")