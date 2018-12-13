begin
$b=true
$a=[]
$aa=[]
while ((a=gets)!="\n")
$a<<a[0..-2]
end
if $a==[]
    $a=[
    "E->TE'",
    "E'->+TE'|^",
    "T->FT'",
    "T'->*FT'|^",
    "F->(E)|id"]
end
$a.map! { |e|
e=e.split('->')
$aa<<e[0]
e=e[1].split('|')
  }
#print $a,$aa
  $a.map!{|e| 
    e.map! { |ee|
        b=[]
        while(ee.length>0)
            if(ee.length>1 && $aa.include?(ee[0..1]))
                b<<ee[0..1]
                ee=ee[2..-1]
            else
                b<<ee[0]
                ee=ee[1..-1]
            end
        end
        ee=b
      }
  }
#print "$a:",$a,"\n"
$firstvalue=Array.new($aa.length) {[]}
$followvalue=Array.new($aa.length) {|i|i==0 ? ["$"] : []}
$aa.length.times { |i| 
#$firstvalue[i]=$a[i].map { |e|e[0]  }.reject { |c| $aa.include?(c) }
}
# $aa.length.times { |i| print "First(",$aa[i],")={",$firstvalue[i].join(','),"}\n"}
# print "\n"
# $aa.length.times { |i| print "Follow(",$aa[i],")={",$followvalue[i].join(','),"}\n"}
while $b
$b=false
$aa.length.times { |i| 
    $a[i].each { |d|n=0
#        print d
#        print d,"   ",$firstvalue[i],$firstvalue[$aa.index(d)],"\n"
bb||=true
while bb
    bb=false
    if $aa.include?(d[n])
        jiance=$firstvalue[$aa.index(d[n])]-$firstvalue[i]-["^"]
        if $firstvalue[$aa.index(d[n])].include?("^")
            if d.length>n+1
                n+=1
                bb=true
            elsif !$firstvalue[i].include?("^")
                $b=true
                $firstvalue[i]<<"^"
            end
        end
    else
        jiance=[d[n]]-$firstvalue[i]
    end
    if (!jiance.empty?)
        $b=true
        $firstvalue[i]+=jiance
    end
end
      }
}
end
$b=true
while $b
$b=false
$aa.length.times { |i| 
    $a[i].each { |ee|
    (ee.length-1).times { |n| if $aa.include?(ee[n])
        if $aa.include?(ee[n+1])
            #print ee[n+1]
            jiance=$firstvalue[$aa.index(ee[n+1])]-$followvalue[$aa.index(ee[n])]-["^"]
            #print jiance
            if (!jiance.empty?)
            $b=true
            $followvalue[$aa.index(ee[n])]+=jiance
            end
        else
            if(ee[n+1]!="^" && !$followvalue[$aa.index(ee[n])].include?(ee[n+1]))
                $b=true
                $followvalue[$aa.index(ee[n])]<<ee[n+1]
            end
        end
    end }
        nn=-1
#        print "ee:",ee
    loop { 
    if $aa.include?(ee[nn])
        #print ee[nn]
            jiance=$followvalue[i]-$followvalue[$aa.index(ee[nn])]-["^"]
            if (!jiance.empty?)
            $b=true
            $followvalue[$aa.index(ee[nn])]+=jiance
            end
    else
        break
    end 
    if ee.length>-nn && $firstvalue[$aa.index(ee[nn])].include?("^")
        nn-=1
    else
        break
    end
     }
      }  }
end
$aa.length.times { |i| print "First(",$aa[i],")={",$firstvalue[i].join(','),"}\n"}
print "\n"
$aa.length.times { |i| print "Follow(",$aa[i],")={",$followvalue[i].join(','),"}\n"}
print "\n"
=begin
E->TE'
E'->+TE'|^
T->FT'
T'->*FT'|^
F->(E)|id

+id*+id

S->ABC
A->a|^
B->b
C->c

S->MH|a
H->LSo|^
K->dML|^
L->eHf
M->K|bLM

A->BaC
B->^
C->^

E->EE+|EE*|a
=end
# print "\n\t",($signal=($firstvalue.flatten+$followvalue.flatten).uniq-['^']).join("\t\t"),"\n"
# $beach=Array.new($aa.length) { |i|hash=Hash.new("");
#     $signal.each { |e| 
#     $a[i].length.times { |n| #print "e",e,"  n",n,"   ",$a[i][n],$a[i][n][0]=="^","\n"
#     if $followvalue[i].include?(e)
#         hash[e]="synch"
#     end
#     if $a[i][n][0]==e or ($aa.include?($a[i][n][0] ) and $firstvalue[$aa.index($a[i][n][0])].include?(e) )  or ($a[i][n][0]=="^" and $followvalue[i].include?(e))
#         hash[e]=[$aa[i],$a[i][n]]
#         #print "hash:",e,"   ",hash[e],"\n"
#     end}}
#     hash}
# $aa.length.times { |n|print $aa[n],"\t",$signal.map { |e|
#     $beach[n][e].class== Array ? (a=$beach[n][e][0]+"->"+($beach[n][e][1].join("")))+(" "*(8-a.length)) : $beach[n][e]+" "*(8-$beach[n][e].length)  }.join("\t"),"\n"  }
# print "\n\n"
# $str=gets[0..-2]+'$'
# $stack=['$','E']
# cha=0
# while(cha<$str.length) 
#     c=$str[cha]
#     print "stack:",$stack,"字符串:",$str[cha..-1],"\n"
#     if c==$stack[-1]
#         $stack.pop
#         cha+=1
#         next
#     end
#     d=$beach[$aa.index($stack[-1])][c]
#         print (d=="synch" ? "synch" : d=="" ? "空白出错" : d[0]+"->"+d[1].join ),"\n"
#     if d==""
#         print "出错，跳过",c,"\n"
#         cha+=1
#     elsif d=="synch"
#         print "出错，“",c,"”正好在",$stack[-1],"的同步记号集合中，无须跳过任何记号;",$stack[-1],"被弹出。\n"
#         $stack.pop
#     elsif d[1][0]=='^'
#         $stack.pop
#     else
#         $stack.pop
#         $stack+=d[1].reverse
#         #print $stack,c,d,"\n"
#     end
# end
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end
system "pause"