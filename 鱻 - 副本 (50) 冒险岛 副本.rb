Length_of_bar=120
begin
$LOAD_PATH.unshift(File.dirname(__FILE__))
	require "tk"
	require "鱻 - 副本 (52)Figure类 - 副本.rb"

EneList=[Ene.new("羊"),
		 Ene.new("鸡",2,2,6,[2,2,2,2,2],2),
		 Ene.new("兔子",3,1,8),
		 Ene.new("牛",8,2,4),
		 Ene.new("牧羊人",48,4,6.2,[0,10,5,0,0],5,2,4)
		]
		print EneList[1].dup
t1= Figure.new("动物",70,30,6)
t2= Hero.new("人",1,100,20,4)
Figure.Battle t1,t2
Figure.Battle t1,t2
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"