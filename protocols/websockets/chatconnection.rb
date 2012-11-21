module Protocols
  module WebSockets
    class ChatConnection
      # Public: Connection socket
      attr_reader :socket

      # Public: Connection user
      attr_reader :user

      # Publci: Connection room
      attr_reader :room

      # Public: Initialize the connection instance
      def initialize(socket)
        @socket = socket
      end

      # Public: Event triggered when the connection is opened
      #
      # Returns nothing
      def onopen
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
      end
    end
  end
end