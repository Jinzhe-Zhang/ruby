begin
$b=true
$a=[]
$aa=[]
while ((a=gets)!="\n")
$a<<a[0..-2]
end
if $a==[]
    #$a=["L->E","E->E+T|T","T->T*F|F","F->(E)|9"]
    #$a=["E->E+T|T","T->T*F|F","F->(E)|i"]
    $a=["L->E:print(E.val)","E->E1+T:E.val=E1.val+T.val|T:E.val=T.val","T->T1*F:T.val=T1.val*F.val|F:T.val=F.val","F->(E):F.val=E.val|digit:F.val=digit.to_i"]
    #$a=["S->aS|bS|a"]

end
$a.map! { |e|
e=e.split('->')
$aa<<e[0]
e=e[1].split('|')
  }
$grammar=$a.map{|e|e.map{|ee|ee.split(':')[1]}}
  $a.map!{|e| 
    e.map! { |ee|
        ee=ee.split(':')[0]
        b=[]
        while(ee.length>0)
            if ee.length>4 && 'digit'==ee[0..4]
                b<<ee[0..4]
                ee=ee[5..-1]
            elsif(ee.length>1 && ($aa.include?(ee[0..1])||ee[1]<='9'&&ee[1]>='0'))
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
print "$a:",$a,"\n$aa:",$aa,"\n"
    $grammar.map!.with_index { |ee,ii|
        ee.map!.with_index { |e,i|print $a[ii][i]
        e.gsub!(/[A-Z]([0-9])?/){|s|s==$aa[ii] ? 'l' : (('$gram['+($a[ii][i].index(s)-$a[ii][i].length).to_s) +']')}
        e.gsub!(/\.val/,'')
      }  }
 print "4444444444",$grammar
 print "$a:",$a,"\n"
$a.map!{|e| e.map! { |ee| ee.map! { |eee|
    eee.gsub!(/[A-Z][0-9]/){|s|s=s[0]}
    eee}}}
 print "$a:",$a,"\n"
$firstvalue=Array.new($aa.length) {[]}
#$followvalue=Array.new($aa.length) {[]}
#$followvalue[0]=["$"]
$aa.length.times { |i| 
$firstvalue[i]=$a[i].map { |e|e[0]  }.reject { |c| $aa.include?(c) }
#$followvalue[i]=(!$a[i].map { |e|e[-1]  }.reject { |c| $aa.include?(c) || c=="^" }.empty?)? ["$"] : $followvalue[i]
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
loop { 
    if $aa.include?(d[n])
        jiance=$firstvalue[$aa.index(d[n])]-$firstvalue[i]-["^"]
        if (!jiance.empty?)
            $b=true
            $firstvalue[i]+=jiance
        end
        if d.length>n+1 && $firstvalue[$aa.index(d[n])].include?("^")
            n+=1
        else
            break
        end
    else
        break
    end
         }
      }
}
 end
 print $firstvalue,"\n\n\n"
$beach=[]
def printt
    $state.each_with_index { |e,i|print 'I',i,":"
     e.each { |ee|
        print "\t",ee[0],"->",ee[1].join,"。",ee[2].join,"   ",ee[3],"   from:",ee[4],"\n"  } }
     print("\n\n")
end
def printtt
    $beach.each_with_index { |e,i|print i,"\t",e,"\n"  }
end
$n=[0,0]
$state=[[["BG",[],[$aa[0]],['$'],"acc"]]]
loop { 
printt
if($state[$n[0]][$n[1]][2]!=[] and $aa.include?(a=$state[$n[0]][$n[1]][2][0]))
    $a[$aa.index(a)].each { |e| 
         # print e.length>1,e,e[1]
          #print $state[$n[0]][$n[1]][3],"haha"
        if !$state[$n[0]].map{|ed|ed[0..3]}.include?(bb=[a,[],e, $state[$n[0]][$n[1]][2].length>1 ? $aa.index($state[$n[0]][$n[1]][2][1]) ? $firstvalue[$aa.index($state[$n[0]][$n[1]][2][1])] : [$state[$n[0]][$n[1]][2][1]] : $state[$n[0]][$n[1]][3]])
        if ab=$state[$n[0]].map{|ed|ed[0..2]}.index(bb[0..2])
            $state[$n[0]][ab][3]+=bb[3]
        else
        $state[$n[0]]<<(bb<<$n[0])
        end
        end
    }
end
    $n[1]+=1
if $n[1]==$state[$n[0]].length
    aa||=[[],[],[]]
    eedupary||=[]
    $state[$n[0]].each{ |ee|
    if ee[2]!=[]
        eedup=Marshal.load(Marshal.dump(ee))
        eedup[1].push(eedup[2].shift)
        eedupary<<eedup
    end
    }
    eedupary=eedupary.group_by{|ee|ee[1][-1]}.values
    print eedupary
    ii||=0
    eedupary.each{ |ee|
    istatee =-1
        $state.each_with_index { |e,istate|
        if ee.map { |ed| ed[0..3] }==e.select { |ed| ed[4]!=istate }.map { |ed| ed[0..3] }
            istatee=istate
            break
        end
        }
        if (istatee<0)
            #print("ha",$state.flatten(1),eedup,"\n")
            #print aa,eedup,aa[0].include?(eedup),"jhhhhhhhhh\n"
            $state<<ee
                #print $beach,eedup
                $beach[$n[0]]||=Hash.new
                $beach[$n[0]][ee[0][1][-1]]=$state.length-1
                #print "$beach[",$n[0],"][",ee[2][0],"]=",$beach[$n[0]][ee[2][0]]
        else
            $beach[$n[0]]||=Hash.new
            $beach[$n[0]][ee[0][1][-1]]=istatee
        end
      }
    $n[0]+=1
    print $n[0],$state.length,"\n"
    $state[$n[0]..-1].each_with_index { |ee,ie|
                ee.each { |eee|
                    print "eee:",eee,"\n"
                if eee[2]==[]
                $beach[$n[0]+ie]||=Hash.new
                # if eedup[]=="BG"
                #     $beach[$state.length-1]||=Hash.new
                #     $beach[$state.length-1]["$"]="acc"
                # else
                eee[3].each { |eeee| 
                #print "\n",eee[4],"   ",eee[0],"   ",$beach,eee[4]==0,$beach[eee[4]],"\n"
                $beach[$n[0]+ie][eeee]=eee[4]=="acc" ? "acc" : [eee[1],eee[0],$grammar[$aa.index(eee[0])][$a[$aa.index(eee[0])].index(eee[1])]]
                }
                # end
                end
                }  
                }
if $n[0]==$state.length
    break
else
    $n[1]=0
end
end
 }
printt
printtt

str=gets[0..-2]+"$"
state=[0]
stack=[]
$gram=[]
puts "state:0\n"
i=0
    digit||=0
    l||=0
loop{ 
    e=str[i]
    print e,"\n"
    if e<='9'&&e>='0'
        digit=e
        e='digit'
    end
    if a=$beach[state[-1]][e]
        puts "\n\nstr:#{str[i..-1]}\nstate#{state}\nstack:#{stack}\n"
        if a=="acc"
        puts "完成，接受"
        elsif a.class==Integer
            state<<a
            stack<<e
            $gram<<e
        else
            eval(a[2])
            $gram.pop(a[0].length)
            $gram<<l
            state.pop(a[0].length)
            state<<$beach[state[-1]][a[1]]
            stack.pop(a[0].length)
            stack.push(a[1])
            i-=1
        end
    else
        puts "出错"
    end
    i+=1
    if !str[i]
        break
    end
}
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end
system "pause"

=begin
L->E:print(E.val)
E->E1+T:E.val=E1.val+T.val|T:E.val=T.val
T->T1*F:T.val=T1.val*F.val|F:T.val=F.val
F->(E):F.val=E.val|digit:F.val=digit.to_i
=end