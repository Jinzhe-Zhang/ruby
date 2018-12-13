a="qwerasdf"
a.gsub!("q") { |match| return "r" }
print a 
system "pause"