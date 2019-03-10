begin
    p "hello"
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end