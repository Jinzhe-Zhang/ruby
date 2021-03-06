
begin
	#!/usr/bin/ruby
require 'thread'
mutex = Mutex.new
 
cv = ConditionVariable.new
a = Thread.new {
   mutex.synchronize {
      puts "A: I have critical section, but will wait for cv#{Time.now}"
      sleep(3)
      cv.wait(mutex)
      puts "A: I have critical section again! I rule!#{Time.now}"
      sleep(2)
   }
}
 
puts "(Later, back at the ranch...)#{Time.now}"
 
b = Thread.new {
   mutex.synchronize {
      puts "B: Now I am critical, but am done with cv#{Time.now}"
      sleep(2.5)
      cv.signal
      puts "B: I am still critical, finishing up#{Time.now}"
      sleep(2.5)
   }
}







rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"