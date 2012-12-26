require 'spec_helper'

describe Chat::Message do
  context "system" do
    let(:message) { Chat::Message.new(@chat, {}, { :type => :system, :text => "Hello" }) }

    describe "#new" do
      it "takes 2 option arguments and creates a Message object" do
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
      it "converts the Message a JSON string" do
        message.to_json.should eql "{\"type\":\"system\",\"text\":\"Hello\",\"user\":null}"
      end
    end

    describe "#public?" do
      it "returns whether the message is to be broadcast or sent to one client" do
        message.public?.should be_true
      end
    end
  end

  context "textual" do
    let(:message) { Chat::Message.new(@chat, {}, { :type => :text, :user => Chat::User.new(2, "Dummy", "dummy@example.com", 1, "ff0000", true), :text => "Hello there" }) }

    describe "#new" do
      it "takes 3 option arguments and creates a Message object" do
        message.should be_an_instance_of Chat::Message
      end
    end

    describe "#type" do
      it "returns the type of the message" do
        message.type.should eql :text
      end
    end

    describe "#text" do
      it "returns the text of the message" do
        message.text.should eql "Hello there"
      end
    end

    describe "#to_json" do
      it "converts the message and the user to a JSON string" do
        message.to_json.should eql "{\"type\":\"text\",\"text\":\"Hello there\",\"user\":{\"id\":2,\"name\":\"Dummy\",\"email\":\"dummy@example.com\",\"hash\":\"6e8e0bf6135471802a63a17c5e74ddc5\",\"role\":1,\"color\":\"ff0000\",\"nsfw\":true}}"
      end
    end

    describe "#public?" do
      it "returns whether the message is to be broadcast or sent to one client" do
        message.public?.should be_true
      end
    end
  end

  context "with a command" do
    let(:message) { Chat::Message.new(@chat, {}, { :type => :text, :user => Chat::User.new(2, "Dummy", "dummy@example.com", 1, "ff0000", true), :text => "/ping" }) }

    describe "#executable?" do
      it "says if the message contains a command" do
        message.executable?.should be_true
      end
    end

    describe "#execute" do
      before do
        message.execute!
      end

      it "tranforms the message into a command response" do
        message.type.should eql :response
      end

      it "removes the user from the message" do
        message.user.should be_nil
      end

      it "says that the message be sent back to one client" do
        message.public?.should be_false
      end

      it "places response value into the message text" do
        message.text.should eql "pong"
      end
    end
  end
end
