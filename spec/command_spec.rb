require 'spec_helper'

describe Chat::Command do
  describe "#ping" do
    it "returns pong" do
      Chat::Command::ping.should eql "pong"
    end
  end
end