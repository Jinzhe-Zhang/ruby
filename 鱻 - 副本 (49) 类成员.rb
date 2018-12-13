
begin
	class Test
def initialize()
@name = "test attr"
end
end

t= Test.new
puts t.name
t.name = "test attr modify"
puts t.name 





rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"