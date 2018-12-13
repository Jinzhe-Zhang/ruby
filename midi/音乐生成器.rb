begin
	def big(a,b)
	if b-a<=1
		return a
	elsif $m[(a+b)/2.to_i-1]>$ee
		big(a,(a+b)/2.to_i)
	else
big((a+b)/2.to_i,b)
end
end
$s=false
	$jj={
'a'=>200,
's'=>100,
'd'=>100,
'f'=>70,
'g'=>200,
'h'=>0,
'j'=>180,
'k'=>120,
'l'=>60,
';'=>150,

'w'=>100,
'e'=>80,
'r'=>40,
't'=>100,
'y'=>20,
'u'=>40,
'i'=>20,
'o'=>5,
'p'=>7,
' '=>5000,

'z'=>4,
'x'=>3,
'c'=>4,
'v'=>2,
'm'=>50,
','=>70,
'.'=>30,
'['=>100
}
$m=[]
puts "The title\n"
$n=gets
if $n=="\n"
	$n="011120000"
end
$s=0
$jj.values.each do 
	|e| 
	$s+=e
$m<<$s
end
@s||=''
30.times{300.times{
 	$ee=rand($s)

n=$jj.keys[big(0,$jj.length)]
print n,"\n"
if @s != n 
$n<<n
@s=n
end
 }
 $n<<" tt yasdfjkl;ttt \n"}
 $n.gsub!("[") { |match|
  $s=!$s
 $s ? "[" : "]" }
 if $s
 	$n<<"]"
 end
aFile = File.new("m.txt", "w")
   aFile.syswrite($n)
require './midi生成器.rb'
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end