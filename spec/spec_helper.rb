require_relative '../chat/user'
require_relative '../chat/message'

require 'yaml'
require 'mocha'
require 'mock_redis'
require 'json'
require 'digest/md5'

RSpec.configure do |config|
  config.before :all do
    @redis = MockRedis.new
    Redis.stubs(:new).returns(@redis)
  end

  config.before :each do
    @redis.flushdb
  end
end