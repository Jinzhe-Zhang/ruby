begin
class Node
    attr_accessor :left,:right,:value,:black,:name
    def initialize(e,n="")
        @left,@right,@value,@black,@name=nil,nil,e,false,n
    end
    def print
        return (@name+(@black ? "◆" : "◇")+@value.to_s)
    end
end
class RBT
    @@root=nil
    def initialize(*op)
        @jl=[]
        op.each { |e|
            add(e)
        }
    end
    def add(e,n="")
        if @@root
            @jl=[@@root]
            while @jl[-1]
                if @jl[-1].value>e
                    @jl<<false<<@jl[-2].left
                else
                    @jl<<true<<@jl[-2].right
                end
            end
            if @jl[-2]
                @jl[-1]=@jl[-3].right=Node.new(e,n)
            else
                @jl[-1]=@jl[-3].left=Node.new(e,n)
            end
            fitadd
        else
            @@root=Node.new(e,n)
        end
        @@root.black = true
    end
    def fitadd
        loop {
            if @jl[-3].black
                return
            elsif brother(-3) and !brother(-3).black
                brother(-3).black,@jl[-3].black,@jl[-5].black= true,true,false
                if @jl.length<=5
                    break
                end
                @jl.pop(4)
            else
                rotate
                break
            end
        }
    end
    def fitdel
        loop {
            if @jl.length==1
                break
            elsif !brother(-1)
                @jl.pop(2)
            else
                if !brother(-1).black
                    die,@jl[-1],@jl[-2]=@jl[-1],brother(-1),!@jl[-2]
                    smallrotate
                    @jl<<@jl[-2]<<die
                end
                if redson(brother(-1))
                    @jl[-1]=brother(-1)
                    @jl[-2]=!@jl[-2]
                    if @jl[-1].left and !@jl[-1].left.black
                        @jl<<false<<@jl[-2].left
                    else
                        @jl<<true<<@jl[-2].right
                    end
                    @jl[-1].black = true
                    rotate
                    break
                else
                    brother(-1).black= false
                    if @jl[-3].black
                        @jl.pop(2)
                    else
                        @jl[-3].black = true
                        break
                    end
                end
            end
        }
    end
    def rotate
        newfamily=[]
        if @jl[-2] and @jl[-4]
            newfamily=[@jl[-5].left,@jl[-5],@jl[-3].left,@jl[-3],@jl[-1].left,@jl[-1],@jl[-1].right]
        elsif @jl[-2]
            newfamily=[@jl[-3].left,@jl[-3],@jl[-1].left,@jl[-1],@jl[-1].right,@jl[-5],@jl[-5].right]
        elsif @jl[-4]
            newfamily=[@jl[-5].left,@jl[-5],@jl[-1].left,@jl[-1],@jl[-1].right,@jl[-3],@jl[-3].right]
        else
            newfamily=[@jl[-1].left,@jl[-1],@jl[-1].right,@jl[-3],@jl[-3].right,@jl[-5],@jl[-5].right]
        end
        newfamily[3].left,newfamily[3].right,newfamily[1].left,newfamily[1].right,newfamily[5].left,newfamily[5].right=newfamily[1],newfamily[5],newfamily[0],newfamily[2],newfamily[4],newfamily[6]
        newfamily[3].black,@jl[-5].black=@jl[-5].black,newfamily[3].black
        update_fathernode(@jl.length-5,newfamily[3])
    end
    def brother(n)
        if @jl[n-1]
            return @jl[n-2].left
        else
            return @jl[n-2].right
        end
    end
    def reverse(m,n)
        i,j,k,l=@jl[m].left,@jl[m].right,@jl[n].left,@jl[n].right
        @jl[m].left,@jl[m].right,@jl[n].left,@jl[n].right = k==@jl[m] ? @jl[n] : k,l==@jl[m] ? @jl[n] : l,i==@jl[n] ? @jl[m] : i,j==@jl[n] ? @jl[m] : j
        if m-n !=2
            update_fathernode(m,@jl[n])
        end
        if n-m !=2
            update_fathernode(n,@jl[m])
        end
        @jl[m].black,@jl[n].black=@jl[n].black,@jl[m].black
        @jl[m],@jl[n]=@jl[n],@jl[m]
    end
    def drawnode(x,n)
        if n
            s=drawnode(x+10,n.left)+[" "*x+"#{n.print}          "]+drawnode(x+10,n.right)
            t=!n.left && n.right
            s.map! { |e| 
                if e[x+10]!=" "
                    t=!t
                    if e[x]==" "
                        e[x+9]="|"
                    else
                        e[x+8]="|"
                    end
                end
                if t
                    if e[x]==" "
                        e[x+9]="|"
                    else
                        e[x+8]="|"
                    end
                end
                e
            }
            return s
        else
            return []
        end
    end
    def draw(n=@@root)
        if n
            d=drawnode(0,n).map { |e|e.chomp  }
            indent=60-d.map { |e| e.length }.max/2
            d.map! { |e| " "*indent+e }
            return d.join("\n")+"\n"
        end
        return "                                                  连根儿都没有的空树\n"
    end
    def del(e)
        if find(e)
            while @jl[-1].left && @jl[-1].right
                pp=@jl.length-1
                @jl<<false<<@jl[-2].left
                while @jl[-1].right
                    @jl<<true<<@jl[-2].right
                end
                reverse(pp,@jl.length-1)
            end
            if @jl[-1].left
                @jl[-1].left.black= true
                update_fathernode(@jl.length-1,@jl[-1].left)
            elsif @jl[-1].right
                @jl[-1].right.black= true
                update_fathernode(@jl.length-1,@jl[-1].right)
            else
                update_fathernode(@jl.length-1,nil)
                if @jl[-1].black
                    fitdel
                else
                end
            end
        end
    end
    def find(e)
        if @@root
            @jl=[@@root]
            while @jl[-1]
                if @jl[-1].value>e
                    @jl<<false<<@jl[-2].left
                elsif @jl[-1].value<e
                    @jl<<true<<@jl[-2].right
                else
                    return true
                end
            end
        end
        return false
    end
    def redson(n)
        return ((n.left and not n.left.black) or (n.right and not n.right.black))
    end
    def update_fathernode(pos,n)
        if pos==0
            @@root=n
        elsif @jl[pos-1]
            @jl[pos-2].right=n
        else
            @jl[pos-2].left=n
        end
    end
    def smallrotate
        if @jl[-2]
            @jl[-1].left,@jl[-3].right=@jl[-3],@jl[-1].left
        else
            @jl[-1].right,@jl[-3].left=@jl[-3],@jl[-1].right
        end
        update_fathernode(@jl.length-3,@jl[-1])
        @jl[-1],@jl[-3],@jl[-2]=@jl[-3],@jl[-1],!@jl[-2]
        @jl[-1].black,@jl[-3].black=@jl[-3].black,@jl[-1].black
    end
end
r=RBT.new(1,2,3,4,5,6)
puts r.draw
r.del(1)
puts r.draw
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end
system "pause"