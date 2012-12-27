#--
# Copyright (c) 2012 Eugen Rochko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy 
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights 
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
# copies of the Software, and to permit persons to whom the Software is 
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
# SOFTWARE.
#++

require 'yaml'
require 'redis'
require 'json'
require 'time'
require 'socket'
require 'digest/md5'
require 'eventmachine'
require 'em-websocket'

Dir["#{File.dirname(__FILE__)}/chat/*.rb"].each           { |file| require file }
Dir["#{File.dirname(__FILE__)}/chat/protocols/*.rb"].each { |file| require file }

EventMachine.run do
  puts "[#{Time.now}] Starting Colorchat"
  chat = Chat::Main.new

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => (ARGV[0] || 8050)) do |socket|
    puts "[#{Time.now}][WebSocket] #{Socket.unpack_sockaddr_in(socket.get_peername).join(':')} - Connection initialized"
    connection = Chat::Protocols::WebSockets.new socket, chat

    socket.onopen    {        connection.onopen }
    socket.onclose   {        connection.onclose }
    socket.onmessage { |data| connection.onmessage data }

    socket.onerror do |error|
      puts "[#{Time.now}][WebSocket] #{Socket.unpack_sockaddr_in(socket.get_peername).join(':')} - Connection error: #{error}"
    end
  end
end
