require 'spec_helper'

describe Chat::Message do
  context "system" do
    let(:message) { Chat::Message.new }

    describe "#new" do
      it "returns a Message object" do
        message.should be_an_instance_of Chat::Message
      end
    end
  end
end