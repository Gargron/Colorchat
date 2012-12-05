require 'spec_helper'

describe Chat::Command do
  let(:message) { Chat::Message.new({}) }

  describe "#ping" do
    it "returns pong" do
      Chat::Command.ping(message).should eql "pong"
    end
  end
end
