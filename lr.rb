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
    $a=["S->L=R|R","R->L","L->aR|b"]
    #$a=["S->aS|bS|a"]

end
$a.map! { |e|
e=e.split('->')
$aa<<e[0]
e=e[1].split('|')
  }
print "$a:",$a,"\n$aa:",$aa,"\n"
  $a.map!{|e| 
    e.map! { |ee|
        b=[]
        while(ee.length>0)
            if(ee.length>1 && ($aa+['id']).include?(ee[0..1]))
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
 print "$a:",$a,"\n"





$firstvalue=Array.new($aa.length) {[]}
$followvalue=Array.new($aa.length) {|i|i==0 ? ["$"] : []}
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
            $state[$n[0]][ab][3]+=bb[3]-$state[$n[0]][ab][3]
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
                $beach[$n[0]+ie][eeee]=eee[4]=="acc" ? "acc" : [eee[1],eee[0]]
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
puts "state:0\n"
i=0
loop{ 
    e=str[i]
    if a=$beach[state[-1]][e]
        puts "str:#{str[i..-1]}\nstate#{state}\nstack:#{stack}\n"
        if a=="acc"
        puts "完成，接受"
        elsif a.class==Integer
            state<<a
            stack<<e
        else
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