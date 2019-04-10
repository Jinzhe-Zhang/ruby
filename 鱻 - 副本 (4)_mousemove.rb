
begin
require 'Win32API'

#定义API GetCursorPos和SetCursorPos的接口
$get_cursor_pos = Win32API.new("user32","GetCursorPos",['P'],'V')
$set_cursor_pos = Win32API.new("user32","SetCursorPos",['i']*2,'V')

#获取鼠标位置
lpPoint ="\0" * 8    #初始化存储位置信息的变量
$get_cursor_pos.Call(lpPoint)        #调用AP
x, y = lpPoint.unpack("LL")        #将传回的参数转换为两个无符号的长整数
puts "当前鼠标的坐标为： #{x}, #{y}"

#设置鼠标位置
def setm(new_xy)
  $set_cursor_pos.Call(new_xy[0], new_xy[1])
end

500.times{
  setm([rand*1280,rand*600])
  sleep 0.1
}



rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"