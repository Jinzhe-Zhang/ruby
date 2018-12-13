require "tk"
root = TkRoot.new()
@canvas = TkCanvas.new(root)

a=TkcRectangle.new(@canvas, '1c', '2c', '3c', '3c',
                )
 a.outline = 'black';a. fill = 'blue'
b= TkcLine.new(@canvas, 0, 0, 100, 100,
                )
                b. width = '2'
                 b.fill = 'red'
@canvas.pack
Tk.mainloop