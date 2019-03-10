
begin

	require "Win32API"
require 'win32/sound'
include Win32
$jj={ 
"\"a\""=>256,
"\"s\""=>288,
"\"d\""=>322.5,
"\"f\""=>341.333,
"\"j\""=>384,
"\"k\""=>426,
"\"l\""=>480,
"\";\""=>512,
"\"A\""=>271.222,
"\"S\""=>304.43,
"\"F\""=>362,
"\"J\""=>406.37,
"\"K\""=>456,

}
puts "256,271.222,288,304.43,322.5,341.333,362,384,406.37,426,456,480,512"
def getch
  @getch ||= Win32API.new('crtdll', '_getch', [], 'L')
  @getch.call
end
j1=Thread.new{
	while (c = getch) != ?\e
		if $jj[c.chr.inspect]
  puts "You typed #{$jj[c.chr.inspect]}"
  print $s,"   ",$jj[c.chr.inspect]-$s,"\n"
end
end

}
j2=Thread.new{
	loop{
	Sound.beep($s=256+rand(256),1000)
sleep (5)
}
}
j1.join
j2.join




rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"