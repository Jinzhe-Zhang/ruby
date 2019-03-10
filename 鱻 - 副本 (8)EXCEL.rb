require 'win32ole'

excel = WIN32OLE.new('Excel.Application')
excel.visible = true
workbook = excel.Workbooks.Add();
worksheet = workbook.Worksheets(1);
worksheet.Range("A1:D1").value = ["North","South","East","West"];
worksheet.Range("A2:B2").value = [5.2, 10];
worksheet.Range("C2").value = 8;
worksheet.Range("D2").value = 20;

range = worksheet.Range("A1:D2");
range.select
chart = workbook.Charts.Add;

workbook.saved = true;
system("Pause")
excel.ActiveWorkbook.Close(0);
excel.Quit();

