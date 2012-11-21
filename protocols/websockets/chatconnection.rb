module Protocols
  module WebSockets
    class ChatConnection
      # Public: Connection socket
      attr_reader :socket

      # Public: Connection user
      attr_reader :user

      # Public: Initialize the connection instance
      def initialize(socket)
        @socket = socket
      end

      # Public: Event triggered when the connection is opened
      #
      # Returns nothing
      def onopen
        @user = User.new 0, "Guest", "guest@example.com", 1, "000000", false
      end

      # Public: Event triggered when the connection is closed
      #
      # Returns nothing
      def onclose
      end

      # Public: Event triggered when data is transmitted through the connection
      #
      # data - String of data
      #
      # Returns nothing
      def onmessage(data)
        message = Message.new { :type => :text, :text => data, :user => @user }
        message.execute! if message.executable?
        @socket.send message.to_json unless message.public?
      end
    end
  end
end