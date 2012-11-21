require 'yaml'
require 'redis'
require 'json'
require 'digest/md5'
require 'eventmachine'
require 'em-websocket'

require_relative './chat/user'
require_relative './chat/command'
require_relative './chat/message'

require_relative './protocols/websockets/chatconnection'

EventMachine.run do
  EventMachine::WebSocket.start(:host => '127.0.0.1', :port => 8050) do |socket|
    connection = Protocols::WebSockets::ChatConnection.new socket

    socket.onopen    {        connection.onopen }
    socket.onclose   {        connection.onclose }
    socket.onmessage { |data| connection.onmessage data }
  end
end