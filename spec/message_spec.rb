require 'spec_helper'

describe Chat::Message do
  context "system" do
    let(:message) { Chat::Message.new { :type => :system, :text => "Hello" } }

    describe "#new" do
      it "returns a Message object" do
        message.should be_an_instance_of Chat::Message
      end
    end

    describe "#type" do
      it "returns the type of the message" do
        message.type.should eql :system
      end
    end

    describe "#text" do
      it "returns the text of the message" do
        message.text.should eql "Hello"
      end
    end

    describe "#to_json" do
      it "returns the JSON string of the message" do
        message.to_json.should eql "{type:\"system\",text:\"Hello\"}"
      end
    end

    describe "#public?" do
      it "returns whether the message is to be broadcast or sent to one client" do
        message.public?.should be_true
      end
    end
  end
end