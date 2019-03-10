#!/usr/bin/env ruby
# 自动查找所有 screen 并 -r , 参数是第几个screen .
# 比如 scr.rb 0 或 scr.rb 1 , 可以 alias s="scr.rb"

s=system "screen"
print s
#该片段来自于http://outofmemory.cn
system "pause"