require 'yaml'
require 'mocha/api'
require 'redis'
require 'mock_redis'
require 'json'
require 'eventmachine'
require 'digest/md5'

require_relative '../chat/user'
require_relative '../chat/command'
require_relative '../chat/message'
require_relative '../chat/room'
require_relative '../chat/list'
require_relative '../colorchat'

RSpec.configure do |config|
  config.before :all do
    @redis = MockRedis.new
    Redis.stubs(:new).returns(@redis)

    @chat  = ColorChat.new
  end
end
