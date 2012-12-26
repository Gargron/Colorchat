module Chat
  module Protocols
    class WebSockets
      # Public: Connection socket
      attr_reader :socket

      # Public: Connection user
      attr_reader :user

      # Public: Connection room
      attr_reader :room

      # Public: Access to the main chat object
      attr_reader :chat

      # Public: ID of the room subscription
      attr_reader :subscription_id

      # Public: Initialize the connection instance
      def initialize(socket, chat)
        @socket = socket
        @chat   = chat
        @room   = chat.root_room
        @subscription_id = @room.subscribe { |data| @socket.send data.encode "UTF-8" }
      end

      # Public: Event triggered when the connection is opened
      #
      # Returns nothing
      def onopen
        @user = Chat::User.new 0, "Guest", "guest@example.com", 1, "000000", false
        @chat.list.add(@user, self)
      end

      # Public: Event triggered when the connection is closed
      #
      # Returns nothing
      def onclose
        @room.unsubscribe @subscription_id
        @chat.list.remove(@user.id, self)
      end

      # Public: Event triggered when data is transmitted through the connection
      #
      # data - String of data
      #
      # Returns nothing
      def onmessage(data)
        message = Chat::Message.new(@chat, { :type => :text, :text => data.encode("UTF-8"), :user => @user })
        message.execute! if message.executable?

        if message.public?
          @room.push(message.to_json)
        else
          @socket.send(message.to_json)
        end
      end
    end
  end
end
