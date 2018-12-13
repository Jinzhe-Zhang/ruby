require 'pathname'
$s=Pathname.new(__FILE__).realpath   

print $s
system "$s"
system "pause"