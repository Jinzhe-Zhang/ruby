require 'net/http'
Net::HTTP.version_1_2   # 设定对象的运作方式
Net::HTTP.start('www.runoob.com', 80) {|http|
  response = http.get('/pets')
  puts response.body
}
system "pause"