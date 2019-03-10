
begin

def change_str(str)
 binding
end
str = "hello"
p eval("str + '  Fred'",change_str("bye"))
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"