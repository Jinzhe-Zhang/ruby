=begin
#input:
        6 7
        add 1 1
        add 2 2
        add 3 3
        find 4 4
        find 3 3
        find 2 3
        find 1 2
output=>
        3
        5
        3
=end
begin
def find(a)
    sum=0
    pos=1
    20.times {|n|
        if a[19-n]==1
            sum+=$aa[pos]
            pos=(pos<<1)+1
        else 
            pos<<=1
        end
    }
    return sum
end
n=gets.split[1].to_i
$aa=Array.new(0x100000,0)
n.times {
    s=gets.split
    a=s[1].to_i
    b=s[2].to_i
    if s[0]=="add"
        a|=0x100000
        while a>0
            if a[0]==0
                $aa[a>>1]+=b
            end
            a>>=1
        end
    else
        p find(b+1)-find(a)
    end
}
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end
system "pause"