require 'Win32API'

def getch
  @getch ||= Win32API.new('crtdll', '_getch', [], 'L')
  @getch.call
end

while (c = getch) != ?\e
  puts "You typed #{c.chr.inspect}"
end###############################################################不要修改