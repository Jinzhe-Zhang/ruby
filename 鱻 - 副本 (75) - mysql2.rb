
begin
require "mysql2"
client = Mysql2::Client.new(:host=>"localhost",:username=>"root",:password=>""
    );
results= client.query("show databases;")
results.each do |row|
  puts row
end
rescue Exception => e
	puts e.backtrace.inspect
	puts e.message
end
system "pause"