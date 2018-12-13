require 'tk'
root = TkRoot.new()

@canvas = TkCanvas.new(root)
@canvas.grid :sticky => 'nwes', :column => 0, :row => 0
TkGrid.columnconfigure( root, 0, :weight => 1 )
TkGrid.rowconfigure( root, 0, :weight => 1 )

@canvas.bind( "3", lambda{|x,y| @lastx = x; @lasty = y;print x ," ", y,"\n";}, "%x %y")
@canvas.bind( "B3-Motion", lambda{|x, y| addLine(x,y)}, "%x %y")

def addLine (x,y)
  TkcLine.new( @canvas, @lastx, @lasty, x, y,).fill='red'
  @lastx = x; @lasty = y; 
end

Tk.mainloop