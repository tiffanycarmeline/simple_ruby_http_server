require 'uri'
require 'cgi'
require 'erb'

class Route
  attr_accessor :request_line, :method, :client
  def initialize(request_line, method, client)
    @request_line = request_line
    @method = method
    @client = client
  end

  def display_path
    request_uri = request_line.split(" ")[1]
    path = URI.unescape(URI(request_uri).path)
    calling_path = path.partition("/")[2]

    if calling_path.length > 0
      display_response_on_browser(calling_path, request_uri)
    else
      #Root
      display_all_routes
    end
  end

  def display_response_on_browser(path, query = '')
    case path
      when "hello-world"
        client.write('Hello World')
      when "foobar"
        foobar(query)
      else
        read_or_write_file("404.html", 'rb')
    end
  end

  def foobar(query) 
    data = []
    string = URI(query)
    s2 = string.query
    uri_break = s2.split("&")
    uri_break.each do |url|
      path_value = url.split("=")
      data << "The value of  #{path_value[0]} is #{path_value[1]} \n"          
    end
    read_or_write_file("list.html", "w", data)
    read_or_write_file("list.html","rb")       
  end

  def read_or_write_file(file_name, mode, data = '')
    File.open(file_name.to_s, mode.to_s) do |file|
      if data.kind_of?(Array)
        data.each do |data|
          file.write(data) if mode == 'w'
        end
      end
      IO.copy_stream(file, client) if mode == 'rb'
    end
  end

  def display_all_routes
    routes = list_of_routes
    data = []
    routes.each do |route, path|
      data << "<a href= #{path}> #{route} </a><br>"
      read_or_write_file("list.html", "w", data)
    end      
    read_or_write_file("list.html", 'rb')    
  end

  def list_of_routes
    routes = {
      "Home" => 'http://localhost:8080',
      "Hello World" => 'http://localhost:8080/hello-world',
      "Foobar" => 'http://localhost:8080/foobar?foos=apple&bars=Mango'
    }
    return routes
  end
end