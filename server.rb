require 'socket'
require './route'

class Server
  attr_accessor :port_number
  
  def initialize(port_number)
    @port_number = port_number
  end

  def start_server
    server = TCPServer.new(port_number)
    keep_listening(server)
  end

  def keep_listening(server)
    loop do
      Thread.new(server.accept) do |client|
        request_path = client.gets
        route = Route.new(request_path, 'GET', client)
        route.display_path
        puts "Connection received from #{client.peeraddr.inspect}"
        puts "Connection from #{client.peeraddr.inspect} terminated"
        client.close
      end
    end
  end
end
ser1 = Server.new(8080)
ser1.start_server