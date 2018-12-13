$LOAD_PATH[0, 0] = File.join(File.dirname(__FILE__), '..', 'lib')
$fin=false
class Block
def initialize(aa)
    @zhan=aa
end

def getzhan
    return @zhan
end

def down?(kj)
    return ((@zhan.map { |e|e+4  }-(kj+@zhan)).empty? and (@zhan&[16,17,18,19]).empty?)
end

def down
return @zhan.map { |e|e+4  }
end

def up?(kj)
    return ((@zhan.map { |e|e-4  }-(kj+@zhan)).empty? and (@zhan&[0,1,2,3]).empty?)
end

def up
    return @zhan.map { |e|e-4  }
end

def left?(kj)
    return ((@zhan.map { |e|e-1  }-(kj+@zhan)).empty? and (@zhan&[0,4,8,12,16]).empty?)
end

def left
    return @zhan.map { |e|e-1  }
end

def right?(kj)
    return ((@zhan.map { |e|e+1  }-(kj+@zhan)).empty? and (@zhan&[3,7,11,15,19]).empty?)
end

def right
    return @zhan.map { |e|e+1  }
end

def printt
p @zhan
end

end
class State
def initialize(ary)
@blocks=[]
    @kj||=ary[0]
    ary[1].each { |e| @blocks<<Block.new(e) }
end
def find
    a=[]
    @blocks.each { |e|
    if e.down?(@kj)
    a<<([(@kj+e.getzhan-e.down).sort]<<(@blocks.map { |ee| (ee==e) ? ee.down : ee.getzhan }.sort))
    end
    if e.left?(@kj)
    a<<([(@kj+e.getzhan-e.left).sort]<<(@blocks.map { |ee| (ee==e) ? ee.left : ee.getzhan }.sort))
    end
    if e.right?(@kj)
    a<<([(@kj+e.getzhan-e.right).sort]<<(@blocks.map { |ee| (ee==e) ? ee.right : ee.getzhan }.sort))
    end
    if e.up?(@kj)
    a<<([(@kj+e.getzhan-e.up).sort]<<(@blocks.map { |ee| (ee==e) ? ee.up : ee.getzhan }.sort))
    end 
    }
    return a
end
def getblocks
    return @blocks
end
def getkj
    return @kj
end
def == (other)
return (@kj==other.getkj and @blocks.map { |e|e.getzhan  }==other.getblocks.map { |e|e.getzhan  })
end
def printt
    
return [@kj]+[@blocks.map { |e|e.getzhan  }]
end
def printtt
    20.times { |n| 
        if n%4==0
            puts ""
        end
        if @kj.include?(n)
            print "\t"
        else 
            10.times { |nn|
                if @blocks[nn].getzhan.include?(n)
                    print nn,"\t"
                end
              }
        end
     }
            puts ""
end
end


begin   
    t=Time.now
    $f=File.open("峰回路转.txt", "a+") { |file|  
    $a=1
    p "Reading"
    hrd||=[[State.new([[12,16],[[0],[1],[2],[3,7],[4,5,8,9],[6,10],[13,14],[11,15],[17],[18,19]]])]]
    while a = file.gets
        hrd<<eval(a).map{ |e| State.new(e) }
        $a+=1
    end
    $hr=Array.new(1900) {[]}
    hrd.flatten.each { |e|  $hr[e.getkj[0]+e.getkj[1]*(e.getkj[1]-1)/2]<<e}
    p "Read finished"
    loop{|t|
           p hrd[-1].length
        hrd<<[]
        hrd[-2].each { |e|e.find.each { |ee| 
            st=State.new(ee) 
            if (!$hr[st.getkj[0]+st.getkj[1]*(st.getkj[1]-1)/2].include?(st))
            hrd[-1]<<st
            $hr[st.getkj[0]+st.getkj[1]*(st.getkj[1]-1)/2]<<st

            if(ee[1].include?([13,14,17,18]))
                p "Find the solution, refinding."
                $refind=[]
                $refind<<st.printt
                while $a>0
                $a-=1
                st.find.each { |eee| 
            e_e=State.new(eee) 
                    if(hrd[$a].include?(e_e))
                        $refind<<eee
                        st=e_e
                        break
                    end
                 }
                end
                p $refind.reverse.map { |e|State.new(e).printtt  }
                $fin=true
                break
            end

            end
        } 
        if($fin)
            break;
        end
            }
        if($fin)
            break;
        end

    p "No."+$a.to_s+" is writing"
       file.syswrite (hrd[-1].map { |e|e.printt  })
       file.syswrite "\n"
    p "No."+$a.to_s+" finished"

    $a+=1
    }
}
p Time.now-t
rescue Exception => e
    p e.backtrace.inspect
    p e.message
end
    system "pause"