
begin # File tk/lib/tk/event.rb, line 457
require 'tk'
require'Win32API'
class Cursor

  M0USEEVENTF_LEFTDOWN  = 2      # 鼠标左键按下键值     
  MOUSEEVENTF_LEFTUP    = 4      # 鼠标左键松开键值

  MOUSEEVENTF_RIGHTDOWN = 0x0008   #右键
 
   MOUSEEVENTF_RIGHTUP = 0x0010 


 
  # 初始化
  def initialize
      # 调用user32.dll的GetCursorPos(得到鼠标坐标)函数
      @getCursorPos = Win32API.new("user32","GetCursorPos",['P'],'V')
      # 调用user32.dll的GetCursorPos(得到鼠标坐标)函数
      @setCursorPos = Win32API.new("user32","SetCursorPos",['i']*2,'V')
      # 调用user32.dll的mouse_event(鼠标事件,如点击)函数
      @mouse_event = Win32API.new("user32","mouse_event",['L']*5,'V')
  end
 
  # 获得鼠标坐标
  def pos
      lpPoint ="\0"*8
      @getCursorPos.Call(lpPoint)
      x,y = lpPoint.unpack("LL")
      return [x,y]
  end
    
  # 设定鼠标坐标
  def pos=(xy)
      @setCursorPos.Call(xy[0],xy[1])
  end
    
  # 按下鼠标左键
  def leftdown
      @mouse_event.Call(M0USEEVENTF_LEFTDOWN,0,0,0,0)
  end
    
  # 松开鼠标左键
  def leftup
       @mouse_event.Call(MOUSEEVENTF_LEFTUP,0,0,0,0)
  end
     
  # 点击鼠标左键(按下提起)
  def click
      leftdown
      leftup
    end
    
end

c=Cursor.new



root = TkRoot.new{
	width 300
	height 300
}
root.title = "Window"


can = TkCanvas.new
l=TkEntry.new
l.place('height'=>20,
	'width'=>350,
	'x'=>0,
	'y'=>0)
can.place('height' => 250,
            'width'  => 350,
            'x'      => 100,
            'y'      => 100)
can.bg("black")
can.bind('KeyPress'){
puts "haha"
}



can.bind('ButtonPress-1',proc{|x,y|}){

puts "#{x},#{y}"
}


Tk.mainloop


rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
	system"pause"
end