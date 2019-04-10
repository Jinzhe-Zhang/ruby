begin #Splay
class Node
    include Enumerable
    attr_accessor :data, :height, :left, :right
    @@root=nil
    def initialize(k)
        @data,@height=k,1
        if !@@root
            @@root=self
        end
    end
    def update_height
        @height = [@left ? @left.height : 0 , @right ? @right.height : 0].max+1
    end
    def <=>(n)
        @data<=>n.data
    end
    def Node.root
        @@root
    end
    def Node.insert(k,&block)
        if @@root
            @@root.insert(k,&block)
        else
            Node.new(k)
        end
    end
    def insert(k,a=[true,@@root],&block)
        if k<@data
            if @left
                a<<false<<@left
                @left.insert(k,a,&block)
            else
                a<<false<<(@left=Node.new(k))
            end
        else
            if right
                a<<true<<@right
                @right.insert(k,a,&block)
            else
                a<<true<<(@right=Node.new(k))
            end
        end
        block.call if block_given?
        if a[0] && a.length>4
            case [a[-4] , a[-2]]
            when [true,true]
                if (!a[-5].left)||(a[-5].left.height<a[-1].height)
                    if a.length==6
                        @@root=a[-3]
                    elsif a[-6]
                        a[-7].right = a[-3]
                    else
                        a[-7].left = a[-3]
                    end
                    a[-5].right,a[-3].left,a[0]=a[-3].left,a[-5],false
                    a[-5].update_height
                end
            when [true,false]
                if (!a[-5].left)||(a[-5].left.height<a[-1].height)
                    if a.length==6
                        @@root=a[-1]
                    elsif a[-6]
                        a[-7].right = a[-1]
                    else
                        a[-7].left = a[-1]
                    end
                    a[-1].right,a[-1].left,a[-5].right,a[-3].left,a[0]=a[-3],a[-5],a[-1].left,a[-1].right,false
                    a[-3].update_height
                end
            when [false,true]
                if (!a[-5].right)||(a[-5].right.height<a[-1].height)
                    if a.length==6
                        @@root=a[-1]
                    elsif a[-6]
                        a[-7].right = a[-1]
                    else
                        a[-7].left = a[-1]
                    end
                    a[-1].left,a[-1].right,a[-5].left,a[-3].right,a[0]=a[-3],a[-5],a[-1].right,a[-1].left,false
                    a[-3].update_height
                end
            when [false,false]
                if (!a[-5].right)||(a[-5].right.height<a[-1].height)
                    if a.length==6
                        @@root=a[-3]
                    elsif a[-6]
                        a[-7].right = a[-3]
                    else
                        a[-7].left = a[-3]
                    end
                    a[-5].left , a[-3].right , a[0] = a[-3].right , a[-5] , false
                    a[-5].update_height
                end
            end
        end
        a[-3].update_height
        a.pop(2)
    end
    def each(&block)
        left.each(&block) if left
        block.call(self)
        right.each(&block) if right
    end
    def each_root_first(&block)
        block.call(self)
        left.each(&block) if left
        right.each(&block) if right
    end
    def each_root_last(&block)
        left.each(&block) if left
        right.each(&block) if right
        block.call(self)
    end
    def each_DFS(a=[],&block)
        block.call(self)
        a<<left if left
        a<<right if right
        if  b=a.shift
            b.each_DFS(a,&block)
        end
    end
    def Node.printt
        p @@root.printt
    end
    def printt
        ans=[@data]
        if @left
            ans<<@left.printt
        end
        if @right
            ans<<@right.printt
        end
        return ans
    end
end
loop {  
y,x=gets.chomp.split
case y
when "insert"
    Node.insert(x.to_i)
when "delete"
    Node.delete(x.to_i)
when "print"
    Node.printt
when "sum"
    p Node.root.inject(0){|a,b|a+=b.data}
end
}
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end

system "pause"

=begin
1 1
1 2
1 3
1 4
1 5
1 6
1 7
1 8
1 9
1 10
1 11
1 12
1 13
1 14
1 15
1 16
1 17
1 18
1 19
1 20
1 21
1 22
1 23
1 24
1 25
1 26
1 27
1 28
1 29
1 30
1 31
1 32
1 33
1 34
1 35
1 36
1 37
1 38
1 39
1 40
1 41
1 42
1 43



=end
