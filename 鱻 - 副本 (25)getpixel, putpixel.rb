
begin
#!/usr/bin/env ruby
# -*- coding: gb18030 -*-
# 2011-3
#ruby 1.8.7 (2011-02-18 patchlevel 334) [i386-mingw32]
#gem 1.6
#gem install win32-api windows-pr windows-api cstruct
#比如要使用 GetDC这个API时,搜索包含文字GetDC的文件在这个目录: D:\Ruby18\lib\ruby\gems\1.8\gems\, 比如我搜索出来是 windows-pr-1.1.3\lib\windows\gdi\device_context.rb , 打开看一下结构.
#则写 require 'windows/gdi/device_context'
#include Windows::GDI::DeviceContext
#同理: GetPixel 在文件 bitmap.rb, 可以打开它过目一下,看一下类结构.
#则写 require 'windows/gdi/bitmap'
#include Windows::GDI::Bitmap
#在Ruby中方便的调用Win32 API (使用windows-pr和CStruct) :
#http://www.w-yong.com/docs/ruby_win32_api.html
#不过代码在结束时,没有重画整个桌面,BUG..

require 'rubygems'
require 'windows/gdi/bitmap'
require 'windows/gdi/device_context'

require 'win32struct'
include Windows::GDI::DeviceContext
include Windows::GDI::Bitmap

module Windows
  module GDI
    module DeviceContext
      API.new('InvalidateRect','LLL','L','user32')
    end
  end
end

class Snow
  SnowNum = 500 #同一时间飘动的雪花数量
  ScrnWidth = 1280 #屏幕宽度(单位:像素)
  ScrnHight = 1024 #屏幕高度(单位:像素)
  SnowColDown = 0xFFFFFF #积雪颜色
  SnowColDuck = 0xFFDDDD #深色积雪颜色
  SnowCol = 0xFEFfFE #雪花颜色

  def initialize
    `title 桌面飘雪` #设置窗口标题
    print "\r按 ctrl + c 结束"
    @hDC1 = GetDC(0)
    #初始化整个屏幕
    @vx=0
    @vy=0
    @px=[]
    @py=[]
    @pColor=[]
    SnowNum.times{|j|
      @px[j] = rand * ScrnWidth
      @py[j] = rand * ScrnHight / 1.5
      @pColor[j] = GetPixel(@hDC1, @px[j], @py[j])
    }
  end

  def timerStart
    #设置计时器，Timer1用于画单帧，Timer2用于风向变化
    Thread.new{
      loop do
      sleep 0.005
      #画出一帧
      draw rescue(p $!.message + $@[0])
      end
    }
    Thread.new{
      loop do
      #改变风向
      @vx = rand * 4 - 2
      @vy = rand + 2      
      sleep 1.4
      end
    }
  end

  #初始化雪花位置
  def initP(i)
    @px[i] = rand * ScrnWidth
    @py[i] = rand * 3
    @pColor[i] = GetPixel(@hDC1, @px[i], @py[i]) #取得屏幕原来的颜色值
  end

  #画出一帧，即重画所有雪花位置一次
  def draw
    SnowNum.times{|i|
      if @pColor[i] != SnowCol
        #还原上一个位置的颜色
        SetPixel @hDC1, @px[i],@py[i], @pColor[i]
      end
      #设置新的位置，i Mod 3用于将雪花分为三类采用不同速度，以便形成层次感
      @pvx = rand * 2 - 1 + @vx * (i%3)
      @pvy = @vy * (i%3+1)
      @px[i] =@px[i] + @pvx
      @py[i] =@py[i] + @pvy

      #取得新位置原始颜色值，用于下一步雪花飘过时恢复此处颜色
      @pColor[i] = GetPixel(@hDC1,@px[i],@py[i])

      #如果获取颜色失败，表明雪花已飘出屏幕，重新初始化
      if @pColor[i] == 0xFFFFFFFF
        initP i
      else
        #否则若雪花没有重叠
        if @pColor[i] != SnowCol
          #若对比度较小(即不能堆积),就画出雪花
          #Rnd()>0.3用于防止某些连续而明显的边界截获所有雪花
          if rand > 0.3 or getContrast(i) < 50
            SetPixel @hDC1,@px[i],@py[i], SnowCol
            #否则表明找到明显的边界，画出堆积的雪，并初始化以便画新的雪花
          else
            SetPixel @hDC1,@px[i],@py[i] - 1, SnowColDuck
            SetPixel @hDC1,@px[i] - 1,@py[i], SnowColDuck
            SetPixel @hDC1,@px[i] + 1,@py[i], SnowColDown
            initP i
          end
        end
      end
    }
  end

  #取得某一点与周围点的对比度，确定是否在此位置堆积雪花
  def getContrast(i)
    #colorCmp = 0 #存储用作对比的点的颜色值
    #tempR = 0 #存储CorlorCmp的红色部分，下同
    #tempG = 0
    #tempB = 0
    #slope=0  #存储雪花飘落方向:Vx/Vy

    #计算雪花飘落方向
    if @pvy != 0
      slope = @pvx / @pvy
    else
      slope = 2
    end
    #根据雪花飘落方向决定取哪一点作对比点，
    #若PVx/PVy在-1到1之间，即Slope=0，就取正下面的象素点
    #若PVx/PVy>1，取右下方的点，PVx/PVy<-1则取左下方
    if slope == 0
      colorCmp = GetPixel(@hDC1, @px[i], @py[i] + 1)
    elsif slope > 1
      colorCmp = GetPixel(@hDC1, @px[i] + 1, @py[i] + 1)
    else
      colorCmp = GetPixel(@hDC1, @px[i] - 1, @py[i] + 1)      
    end
    #确定当前位置没有与另一个雪花重叠，否则返回0，用于防止由于不同雪花重叠造成雪花乱堆
    if colorCmp == SnowCol
      return 0
    end
    #分别获取ColorCmp与对比点的蓝、绿、红部分的差值
    tempB = ((colorCmp & 0xFF0000).abs - (@pColor[i] & 0xFF0000)) / 0x10000
    tempG = ((colorCmp & 0xFF00).abs - (@pColor[i] & 0xFF00)) / 0x100
    tempR = ((colorCmp & 0xFF).abs - (@pColor[i] & 0xFF))
    ##返回对比度值
    (tempR + tempG + tempB) / 3
  end

  def cc
    ReleaseDC 0, @hDC1 #释放桌面窗口设备句柄
    InvalidateRect 0, 0, 0 #清除所有雪花，恢复桌面
  end

  def run
    trap(:INT){exit} #按 c-c 退出
    timerStart #启动定时器

    #等到所有进程退出后,主进程再退出
    while(Thread.list.count != 1) do sleep 1 end     
    cc #结束运行
  end
end

Snow.new.run




rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"