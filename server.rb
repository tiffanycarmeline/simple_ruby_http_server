require 'socket'
require './route'

class Server
  attr_accessor :port_number
  
  def initialize(port_number)
    @port_number = port_number
  end

  def start_server
    socket = TCPServer.new(port_number)
    keep_listening(socket)
  end

  def keep_listening(socket)
    while client = socket.accept
      client.write(Time.now)
      client.print("Hello world") 
      puts "Connection received from #{client.peeraddr.inspect}"
      puts "Connection from #{client.peeraddr.inspect} terminated"
      client.close
    end
  end

  def display_pages
  end
end
ser1 = Server.new(8080)
ser1.start_server