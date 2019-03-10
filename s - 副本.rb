 #!/usr/bin/ruby
 $bo=""
 $b=Array.new(16) { Array.new(16) { 0}  }
 begin
  class Draw
    def win?(x,y)
      (0...5).each { |e| @s=0;(0...5).each { |ee|
        if(x-ee+e>0&&x-ee+e<16&&y-ee+e>0&&y-ee+e<16) 
          @s+= $b[x-ee+e][y-ee+e] 
        else
         break 
        end} ; 
        if(@s==5||@s==-5)
          puts "ya!"
         return true  
       end
     }
     (0...5).each { |e| @s=0;(0...5).each { |ee|
      if(x-ee+e>0&&x-ee+e<16&&y>0&&y<16)
       @s+= $b[x-ee+e][y] 
     else
      break 
     end} ; 
     if(@s==5||@s==-5)
         puts "ya!"
      return true 
    end
  }
  (0...5).each { |e| @s=0;(0...5).each { |ee|
    if(x>0&&x<16&&y-ee+e>0&&y-ee+e<16)
     @s+= $b[x][y-ee+e]
   else
     break 
   end} ;
   if @s==5||@s==-5 
       puts "ya!"
     return true
   end
 }
 (0...5).each { |e| @s=0;(0...5).each { |ee|if(x+ee-e>0&&x+ee-e<16&&y-ee+e>0&&y-ee+e<16)
   @s+= $b[x+ee-e][y-ee+e]
 else 
  break
end} ;
if @s==5||@s==-5 
   puts "ya!"
  return true 
end
}
return false
end 
def board
  $bo=""
  (1..15).each { |e|(1..15).each { |ee|$bo+=((ee==1||ee==15) ? (e==1||e==15 ? "+": "|"):(e==1||e==15 ? "-" : "+"))
   $bo+=(ee==15? "\n":" ")  }  }
   redraw

 end
 def redraw
  system"cls"
  puts $bo
  puts 'please input "x + enter + y + enter" to choose a position'
end
def downblack(x,y)
  $bo[30*y+x*2-32]="&"
  $b[x][y]=1
end
def downwhite(x,y)
  $bo[30*y+x*2-32]="@"
  $b[x][y]=-1
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
     (!d)?downwhite(x,y):downblack(x,y)

     redraw()
     if win?(x,y)
        if d  
          puts'"&" win!'
          else
           puts'"@" win!'
         end


        system"Pause"
        system"cls"
        $b=Array.new(16) { Array.new(16) { 0}  }
       board()
      end
     break
   end}




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