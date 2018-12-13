	#!/usr/bin/env ruby
	begin 
		require 'tk'

		def frame(root)
			f = TkFrame.new(root)
			f.pack(:padx=>5,:pady=>2,:side=>'top')
			return f
		end

		LEFT = {:side=>'left',:padx=>2}

		root = TkRoot.new{title "simple calculator"}

		var_ans = TkVariable.new

		fr1 = frame(root)
		TkEntry.new(fr1) do
			textvariable var_ans
			width 18
			pack LEFT
		end
		for key in ['123','456','789','+0.','-*/','()='] do
			f = frame(root)
			key.each_char do |c|
				if c == '=' the
					TkButton.new(f) do
						text c
						width 4
						command proc {
							var_ans.value = eval(var_ans.value)
						}
						pack
					end
				else
					TkButton.new(f) do
						text c
						width 4
						command proc{var_ans.value +=c}
						pack LEFT
					end
				end
			end
		end

		var_ans.value =""

		root.mainloop
	rescue Exception => e
		puts e.backtrace.inspect
		puts e.message
	end

