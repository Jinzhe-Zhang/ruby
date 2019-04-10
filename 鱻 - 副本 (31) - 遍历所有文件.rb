Dir[File.dirname(__FILE__) + '../*.rb'].each {|file| p file ;require file }

system "pause"