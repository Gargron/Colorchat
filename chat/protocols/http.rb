module Chat
  module Protocols
    class Http < EventMachine::Connection
      include EventMachine::HttpServer

      def process_http_request
        res = EventMachine::DelegatedHttpResponse.new self

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
            res.status  = 200
            res.content = 'Poop'
            res.send_response
          end
        end
      end
    end
  end
end
