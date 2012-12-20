require 'yaml'
require 'redis'
require 'json'
require 'digest/md5'
require 'eventmachine'
require 'em-websocket'

Dir["#{File.dirname(__FILE__)}/chat/*.rb"].each        { |file| require file }
Dir["#{File.dirname(__FILE__)}/protocols/*/*.rb"].each { |file| require file }

EventMachine.run do
  chat = Chat::Main.new

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8050) do |socket|
    connection = Protocols::WebSockets::ChatConnection.new socket, chat

    socket.onopen    {        connection.onopen }
    socket.onclose   {        connection.onclose }
    socket.onmessage { |data| connection.onmessage data }
  end
end
