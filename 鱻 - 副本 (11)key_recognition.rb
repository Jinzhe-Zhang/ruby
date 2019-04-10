require 'tk'
root = TkRoot.new()

@TkCanvas = TkCanvas.new(root)
@TkCanvas.grid :sticky => 'nwes', :column => 0, :row => 0
TkGrid.columnconfigure( root, 0, :weight => 1 )
TkGrid.rowconfigure( root, 0, :weight => 1 )
root.bind( "KeyPress-Up"){ print"haha";} 
root.bind( "KeyPress-", lambda{print"hehe";} )
root.bind( "KeyPress-m", lambda{print"hehe"})
sleep(10)
Tk.mainloop