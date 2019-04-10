begin
p [true,true,true].inject(:and)
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end
system "pause"