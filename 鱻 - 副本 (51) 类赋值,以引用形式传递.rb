
begin
m=Array.new
n=Array.new
class A
	attr_accessor :a
	def initialize
@a =1
end
end
b=A.new
print b.a,"\n"
m<<b.dup
m[0].a-=1
print b.a,"\n"
print m[0].a,"\n"


n<<b
n[0].a-=1
print b.a



rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"