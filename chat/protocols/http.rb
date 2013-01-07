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
      end
    end
  end
end
