
begin
m=1
n=Array.new(1) { |i| 148 }
n.each { |q| 
@s||=0.0
(q+1).times { |nn|
@m||=1.0
if nn>0
@m*=nn
end
print @m,"  ",nn,"\n"
@s+=q**nn/@m 
print "add ",@s,"\n"
  }
  @s/=(271801.0/99990)**(q)
  print "\n\n****The answer is#{@s}\n\n "
 }







rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"