require 'socket'
server = TCPSocket.new('localhost', 8080)
server.puts "Hello!"
puts "Server says: #{server.gets}"
server.close