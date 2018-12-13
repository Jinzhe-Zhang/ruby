require 'tk'

$resultsVar = TkVariable.new
root = TkRoot.new
root.title = "Window - www.yiibai.com"

label = TkLabel.new(root) 
label.image = "zara.jpg"
label.place('height' => 100, 
            'width' => 110 
      	    'x' => 10, 'y' => 10)
Tk.mainloop