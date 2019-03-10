require "Win32API"
begin
	$mouse||=Win32API.new("user32","mouse_event",["L"]*5,"V")
	$g||=Win32API.new('crtdll', '_getch', [], 'L')
	$lor||=1
	$fre||=0.02
	class THREAD
		def begi
			system "cls"
			@@t=Thread.new	{loop{
				sleep ($fre)
				$mouse.Call(2*$lor,0,0,0,0)
				$mouse.Call(4*$lor,0,0,0,0)}
			}
		end
		def beginn(c)
			
			begi
			if c !=0
			puts"好的,运行#{c}s"
		end
			@@s=Thread.new	{
				sleep (c)
			@@t.exit
			if c !=0
			puts"完毕"
		end}
		end
		def stop
			@@s.exit
		    @@t.exit
		end
	end

	tt = THREAD.new
	tt.beginn(0)
	puts "请按下列按键执行操作：\nS无限时开始\nN自定义限时开始\nP停止\nQ退出程序\nT切换速率\nR切换左右键\nA~K定时开始\n0.5s\n2s\n5s\n10s\n20s\n30s\n60s\n2min\n5min\n10min\n20min"
	loop{ee = $g.call
		case ee
		when 115
			tt.stop
			tt.begi
		when 112
			tt.stop
			puts"已停"
		when 97
			tt.stop
			tt.beginn(0.5)
		when 98
			tt.stop
			tt.beginn(2)
		when 99
			tt.stop
			tt.beginn(5)
		when 100
			tt.stop
			tt.beginn(10)
		when 101
			tt.stop
			tt.beginn(20)
		when 102
			tt.stop
			tt.beginn(30)
		when 103
			tt.stop
			tt.beginn(60)
		when 104
			tt.stop
			tt.beginn(120)
		when 105
			tt.stop
			tt.beginn(300)
		when 106
			tt.stop
			tt.beginn(600)
		when 107
			tt.stop
			tt.beginn(1200)
		when 110
			tt.stop
			puts "请输入秒数:\n"
			tim = gets
			tt.beginn(tim.to_i)
		when 113
			exit
		when 114
			$lor=5-$lor
			print"已切换为",$lor==1 ? "左": "右" ,"键\n"
		when 116
			tt.stop
			system "cls"
			puts "(默认20)请输入速率(ms):\n"
			t = gets
			$fre=t.to_f/1000
			puts"已为您设置#{$fre*1000}ms的速率"

		end

	}










rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"