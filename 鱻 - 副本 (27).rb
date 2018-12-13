#ruby提供了多种运行外部程序的方法
#1.%x %x不需要使用引号包含。
#2. system方法 
#3.exec类似system但是会中断当前的代码执行
#system和exec不能捕获执行程序的输出。

begin


list=%x(dir d:\\) #捕获到输出结果
system('notepad')
p 'system'
exec('notepad')
p 'exec'#被exec中断，不会执行下面的代码

require 'Win32API'#调用Win32api
get_cur=Win32API.new("user32","GetCursorPos",['P'],'V')
set_cur=Win32API.new("user32","SetCursorPos",['i']*2,'V')
lpoint=" "*8
get_cur.call(lpoint)
x,y=lpoint.unpack("LL")
p "当前鼠标的坐标为:X:#{x},Y:#{y}"
new_xy=[12,12]
set_cur.call new_xy[0],new_xy[1]


require 'win32ole'#调用win32ole
excel=WIN32OLE.new('excel.application')
excel.Visible=true
excel.WorkBooks.Add
 
excel.Range("a1").value=3
excel.Range('a2').value=2
excel.Range('a3').value=1
excel.Range('b1').value="win32ole操作excel栗子"
excel.Range('a1:a3').select

excel_chart=excel.charts.add
excel_chart.type=-4100
excel.ActiveWorkbook.SaveAs("c:\\test.xls")
excel.ActiveWorkbook.Close(0)
excel.Quit


word=WIN32OLE.new('word.application')
word.Visible=true
word.Documents.Add
word.Selection.TypeText("你好")
word.Selection.TypeParagraph
word.Selection.TypeText("win32ole操作word栗子")
#word.Selection.TypeParagraph

word.Selection.InlineShapes.AddPicture("http://su.bdimg.com/static/superplus/img/logo_white_ee663702.png")#本地和网络图片均可

word.ActiveDocument.SaveAs("c:test.doc")
word.ActiveDocument.close
word.quit


ie=WIN32OLE.new('internetexplorer.application')
ie.visible=true
ie.left=100
ie.top=100
ie.width=700
ie.height=500
ie.navigate 'http://www.baidu.com/s?wd=你好'
sleep 0.1 while ie.busy
script=ie.document.script
script.alert('这是ruby调用的js脚本')
#script.eval('document.location=$("h3>a:eq(0)").attr("href")')#这是个问题。。怎么执行呢
ie.Document.title='修改它的标题'
puts ie.document
ie.quit
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"