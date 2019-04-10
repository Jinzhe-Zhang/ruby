begin
class Treap
    attr_accessor :left#, :right, :data
    attr_accessor :right
    attr_accessor :sze
    attr_accessor :data
    attr_accessor :weight
    def initialize(v)
        @sze,@data,@weight=1,v,rand()
        p "New Treap #{data},weight#{weight}"
    end
    def update
        @sze=1+(left ? left.sze : 0)+(right ? right.sze : 0)
    end
    def printt
        p "Treap #{data},weight#{weight},sze#{sze},left#{@left ? @left.data : ""},right#{@right ? @right.data : ""}"
        if @left
            @left.printt
        end
        if @right
            @right.printt
        end
    end
end
def sze(a)
   return (a ? a.sze : 0 )
end
def merge(a,b)
    if !a
        return b
    end
    if !b
        return a
    end
    if a.weight<b.weight
        a.right=merge(a.right,b)
        a.update
        return a
    else
        b.left=merge(a,b.left)
        b.update
        return b
    end
end
def split(pos,k)
    if !pos
        return nil,nil
    end
    if sze(pos.left)>=k
        x,y=split(pos.left,k)
        pos.left=y
        pos.update
        y=pos
    else
        x,y=split(pos.right,k-1-sze(pos.left))
        pos.left=x
        pos.update
        x=pos
    end
    return x,y
end
def getrank(pos,x)
    if !pos
        return 0
    else
        return (pos.data>=x) ? getrank(pos.left,x) : getrank(pos.right,x)+1+sze(pos.left)
    end
end
def getkth(k)
    x,y=split($root,k-1)
    w,z=split(y,1)
    pos=w
    $root=merge(x,merge(pos,z))
    return pos ? pos.data : 0
end
def insert(d)
    k=getrank($root,d)
    w,x=split($root,k)
    pos=Treap.new(d)
    $root=merge(w,merge(pos,x))
end
def remove(d)
    k=getrank($root,d)
    w,x=split($root,k)
    y,z=split(x,1)
    $root=merge(w,z)
end
gets.chomp.to_i.times {
    y,x=gets.chomp.split.map { |e|e.to_i}
    case y
    when 1
        insert x
    when 2
        remove x
    when 3
        puts getrank($root,x)+1
    when 4
        puts getkth(x)
    when 5
        puts getkth(getrank($root,x))
    when 6
        puts getkth(getrank($root,x+1)+1)
    when 7
        $root.printt
    end
}
rescue Exception => e
    puts e.backtrace.inspect
    print e.message
end
system "pause"