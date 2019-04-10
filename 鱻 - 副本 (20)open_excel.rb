require "WIN32OLE"
excel = WIN32OLE.new('Excel.Application')
excel.visible = true