begin
def change_str(str)
    p "ha"
    binding
end
str = "hello"
eval("p str + '  Fred'",change_str("bye"))
p str

#=>相当于在binding处运行了eval
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"