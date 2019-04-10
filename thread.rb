begin
    require 'thread'
        srand()
    def eat(n)
        a=rand()+2
        puts "Person #{n},eat for #{a.round(2)} seconds"
        sleep(a)
        Thread.current[:eat_time]+=a
    end
    def rest(n)
        a=rand()+1
        puts "Person #{n},rest for #{a.round(2)} seconds"
        sleep(a)
        Thread.current[:rest_time]+=a
    end
    t=Time.now
    mutex=Array.new(5) {  Mutex.new()  }
    thread=Array.new(5){|n|
        Thread.new(){
            Thread.current[:need],Thread.current[:eat_time],Thread.current[:rest_time]=false,0,0
            sleep (0.1)
            10.times{
                mutex[n].lock
                    sleep(0.1)
                        Thread.current[:need]=true
                        while thread[(n-1)%5][:need]
                            mutex[n].unlock
                            sleep(0.1)
                            Thread.current[:need]=false
                            sleep(rand/100)
                            mutex[n].lock
                            sleep(0.1)
                            Thread.current[:need]=true
                        end
                        mutex[(n+1)%5].lock
                    sleep(0.1)
                            Thread.current[:need]=false
                    sleep(0.1)
                            eat(n)
                        mutex[(n+1)%5].unlock
                mutex[n].unlock
            rest(n)
            }
        }
    }
    thread.each { |e|  e.join  }
    thread.each_with_index { |e,i|  puts "Thread #{i} eat_time: #{e[:eat_time]} rest_time: #{e[:rest_time]}"  }
    puts "Total_time: #{Time.now-t}"
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end
system "pause"