require "Win32API"
begin
	puts "请按下列按键执行操作：\nS无限时开始\nN自定义限时开始\nP停止\nQ退出程序\nR切换左右键\nA~K定时开始\n0.5s\n2s\n5s\n10s\n20s\n30s\n60s\n2min\n5min\n10min\n20min"
	sleep(2)
	


rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"