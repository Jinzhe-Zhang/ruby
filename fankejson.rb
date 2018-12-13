# -*- coding: UTF-8 -*-
require 'rubygems'
require 'json'
require 'pp'
begin
def fanketocsv(title,dir='C:\Users\29410\Desktop\out.csv',havetime=true)
    $a=JSON.parse(gets.force_encoding("utf-8")).map { |e| 
        b=e['submitContentList'].map { |ee| ee['val'] }
        havetime ? b.unshift(Time.at e['time'].to_i/1000) : b
         }.unshift((havetime ? title.unshift('时间') : title).map { |e|e.encode('GBK').force_encoding("utf-8")  })
    print $a
    f=File.new(dir,"w")
    f.puts($a.map{|e|e.join(",")}.join("\r"))
    f.close
end
fanketocsv(["姓名","选项"])
rescue Exception => e
    puts e.backtrace.inspect
    puts e.message
end
system "pause"