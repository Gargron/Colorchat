module Chat
  module Protocols
    class Http < EventMachine::Connection
      include EventMachine::HttpServer

      def process_http_request
        # TODO
      end
    end
  end
end
