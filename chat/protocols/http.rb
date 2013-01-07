module Chat
  module Protocols
    class Http < EventMachine::Connection
      include EventMachine::HttpServer

      attr_reader :chat

      attr_reader :subscription_id

      def initialize(chat)
        super()

        @chat = chat
      end

      def process_http_request
        res = EventMachine::DelegatedHttpResponse.new self

        @subscription_id = @chat.root_room.subscribe do |data|
          res.status  = 200
          res.content = data
          res.send_response
        end

        puts "[#{Time.now}] Comet: request_method : #{@http_request_method}"
        puts "[#{Time.now}] Comet: path_info : #{@http_path_info}"
        puts "[#{Time.now}] Comet: query_str : #{@http_query_string}"
        puts "[#{Time.now}] Comet: post_content : #{@http_post_content}"

        if @http_request_method == 'POST'
          res.status  = 200
          res.content = 'OK'
          res.send_response
        elsif @http_request_method == 'GET'
          EventMachine::defer do
            60.times do
              sleep 1
            end

            res.status  = 204
            res.content = ''
            res.send_response
          end
        end
      end
    end
  end
end
