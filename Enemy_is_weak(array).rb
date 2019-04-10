begin
$aa=Array.new(4){Array.new(1<<20) {0}}
$sum=0
gets
gets.chomp.split.map.with_index { |e,i|[(e.to_i),i]}.sort_by{|a|a[0]}.map.with_index{ |e,i|e<<i}.sort_by{|a|a[1]}.map{|a|a[2]}.each { |e|
    20.times { |n|
        if e[n]==0
            $aa[1][e]+=$aa[0][((e>>n)+1)<<n]
            $aa[3][e]+=$aa[2][((e>>n)+1)<<n]
        end
     }
     $sum+=$aa[3][e]
    20.times { |n|
        if e[n]==1
            $aa[0][e>>n<<n]+=1
            $aa[2][e>>n<<n]+=$aa[1][e]
        end
     }
}
p $sum
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end
system "pause"