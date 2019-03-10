
begin
	$cdy=Hash.new {}
@a=gets
@a.gsub!(/(::.*?:)|(:.)/) { |match| if match.length==2
		 						$cdy[match[1]]
		 						else
		 						$cdy[match[2]]=match[3..-2]
		 						""
		 					end }
		 					print @a
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"