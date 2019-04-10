begin
class Node
    attr_accessor :value
    attr_accessor :left
    attr_accessor :right
    attr_accessor :present_smaller_count
    attr_accessor :former_smaller_count
    @@count=false
    def initialize(value)
        nodelist=[self]
        @value=value
        @former_smaller_count=[0,0,0]
        present_smaller_count=[1,0,0]
        if @@count
            r=@@root
            loop { 
                if r.value<@value
                    nodelist << r
                    if r.right
                        r=r.right
                    else
                        r.right=self
                        break
                    end
                else
                    present_smaller_count[1]+=r.former_smaller_count[0]
                    present_smaller_count[2]+=r.former_smaller_count[1]
                    if r.left
                        r=r.left
                    else
                        r.left=self
                        break
                    end
                end 
            }
        else
            @@root=self
            @@count=true
        end
        while aa=nodelist.pop
            aa.former_smaller_count[0]+=present_smaller_count[0]
            aa.former_smaller_count[1]+=present_smaller_count[1]
            aa.former_smaller_count[2]+=present_smaller_count[2]
        end
    end
    def Node.printt
        r=@@root
        a=r.former_smaller_count[2]
        while r.left
            r=r.left
            a+=r.former_smaller_count[2]
        end
        print a
    end
end
gets
gets.chomp.split.each{|e|
    Node.new(e.to_i)
}
Node.printt
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end

system "pause"