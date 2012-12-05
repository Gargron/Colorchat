require_relative '../chat/user'
require_relative '../chat/command'
require_relative '../chat/message'
require_relative '../chat/room'

require 'yaml'
require 'mocha/setup'
require 'redis'
require 'mock_redis'
require 'json'
require 'eventmachine'
require 'digest/md5'

RSpec.configure do |config|
  config.before :all do
    @redis = MockRedis.new
    Redis.stubs(:new).returns(@redis)
  end
end
