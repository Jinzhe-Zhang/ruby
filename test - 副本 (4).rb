begin
    p (3+10.0/16+7.0/256)*1024
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end

system "pause"