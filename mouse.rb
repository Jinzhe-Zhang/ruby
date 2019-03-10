
begin
# Win32API应该可以被多种开发语言所调用， 主要用来操作MS的。
require 'Win32API'
require "tk"
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
      $x,$y = lpPoint.unpack("LL")
      return [$x,$y]
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
$ss=Array.new(5,false) 
root = TkRoot.new
root.bind( "KeyPress-e"){$ss[0]=true}
root.bind( "KeyPress-x"){if $ss[0]==true
  $ss[1]=true
end}
root.bind( "KeyPress-i"){if $ss[1]==true
  $ss[2]=true
else
  $ss[0]=false
end}
root.bind( "KeyPress-t"){if $ss[2]==true
  $ss[3]=true
else
$ss[0]=$ss[1]=false
end}
root.bind( "KeyPress-!"){if $ss[3]==true
  $ss[4]=true
else
$ss[0]=$ss[1]=$ss[2]=$ss[3]=false
end}
root.bind( "KeyPress-"){

 $ss[0]=$ss[1]=$ss[2]=$ss[3]=false
}
sleep(4)

  4.times{

c.pos=([rand*1280,rand*800])
c.click
c.click 
  if $ss[4]
break
  end
sleep 0.03}







rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"