
begin
require 'tk'
require 'tkextlib/tile'

root = TkRoot.new()

@canvas = TkCanvas.new(root) {scrollregion '0 0 1000 1000'}
@h = TkScrollbar.new(root) {orient 'horizontal'}
@v = TkScrollbar.new(root) {orient 'vertical'}
@canvas.xscrollbar(@h)
@canvas.yscrollbar(@v)

@canvas.grid :sticky => 'nwes', :column => 0, :row => 0
@h.grid :sticky => 'we', :column => 0, :row => 1
@v.grid :sticky => 'ns', :column => 1, :row => 0
TkGrid.columnconfigure( root, 0, :weight => 1 )
TkGrid.rowconfigure( root, 0, :weight => 1 )
root.bind( "Return", proc{print "haha!!!!!!!!"})
@canvas.bind( "a", proc{print "haha!!!!!!!!"})
@canvas.bind( "1", proc{|x,y| print "haha";@lastx = @canvas.canvasx(x); @lasty = @canvas.canvasy(y)}, "%x %y")
@canvas.bind( "B1-Motion", proc{|x, y| addLine(@canvas.canvasx(x), @canvas.canvasy(y))}, "%x %y")
@canvas.bind( "B1-ButtonRelease", proc{doneStroke})
print ({}.class)

r = TkcRectangle.new( @canvas, [10, 10, 30, 30, {:fill => 'red', :tags => 'palette paletteblue'}])
r.bind( "1", proc {setColor('red')})

r = TkcRectangle.new( @canvas,[ 10, 35, 30, 55, {:fill => 'blue', :tags => 'palette paletteblue'}])
r.bind( "1", proc {setColor('blue')})

r = TkcRectangle.new( @canvas, [10, 60, 30, 80, {:fill => 'black', :tags => 'palette paletteblack paletteSelected'}])
r.bind( "1", proc {setColor('black')})

@canvas.itemconfigure 'palette', :width => 5

def setColor color
   @color = color
   @canvas.dtag 'all', 'paletteSelected'
   @canvas.itemconfigure 'palette', :outline => 'white'
   @canvas.addtag 'paletteSelected', :withtag, "palette#{color}"
   @canvas.itemconfigure 'paletteSelected', :outline => '#999999'
end

setColor 'black'

def addLine (x,y)
  TkcLine.new( @canvas, [@lastx, @lasty, x, y, {:fill => @color, :width => 5, :tags => 'currentline'} ])
  @lastx = x; @lasty = y;
end
def doneStroke
  @canvas.itemconfigure 'currentline', :width => 1
end

Tk.mainloop




rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"