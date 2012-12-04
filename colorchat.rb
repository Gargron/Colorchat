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

class ColorChat
  # Public: The main room
  attr_accessor :root_room

  # Public: Initialize a new chat
  def initialize
    @root_room = EventMachine::Channel.new
  end
end

EventMachine.run do
  chat = ColorChat.new

  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8050) do |socket|
    connection = Protocols::WebSockets::ChatConnection.new socket, chat

    socket.onopen    {        connection.onopen }
    socket.onclose   {        connection.onclose }
    socket.onmessage { |data| connection.onmessage data }
  end
end