require 'spec_helper'

describe Chat::User do
  context "from scratch" do
    let(:user) { Chat::User.new 2, "Dummy", "dummy@example.com", 1, "ff0000", true }

    describe "#new" do
      it "takes 6 parameters and returns a User object" do
        user.should be_an_instance_of Chat::User
      end
    end

    describe "#id" do
      it "returns the correct user ID" do
        user.id.should eql 2
      end
    end

    describe "#name" do
      it "returns the correct user name" do
        user.name.should eql "Dummy"
      end
    end

    describe "#email" do
      it "returns the correct user e-mail" do
        user.email.should eql "dummy@example.com"
      end
    end

    describe "#role" do
      it "returns the correct user role" do
        user.role.should eql 1
      end
    end

    describe "#color" do
      it "returns the correct user color HEX" do
        user.color.should eql "ff0000"
      end
    end

    describe "#nsfw" do
      it "returns the correct user NSFW preference" do
        user.nsfw.should eql true
      end
    end

    describe "#hash" do
      it "returns the correct user e-mail MD5 hash" do
        user.hash.should eql "6e8e0bf6135471802a63a17c5e74ddc5"
      end
    end
  end

  context "from datastore" do
    let(:user) { Chat::User.from_datastore "12345" }

    before :all do
      store_user = Chat::User.new 2, "Dummy", "dummy@example.com", 1, "ff0000", true
      @redis.set "user:session:12345", store_user.to_json
    end

    describe "#from_datastore" do
      it "takes a datastore identifier and returns a User object" do
        user.should be_an_instance_of Chat::User
      end
    end

    describe "#id" do
      it "returns the correct user ID" do
        user.id.should eql 2
      end
    end

    describe "#name" do
      it "returns the correct user name" do
        user.name.should eql "Dummy"
      end
    end

    describe "#email" do
      it "returns the correct user e-mail" do
        user.email.should eql "dummy@example.com"
      end
    end

    describe "#role" do
      it "returns the correct user role" do
        user.role.should eql 1
      end
    end

    describe "#color" do
      it "returns the correct user color HEX" do
        user.color.should eql "ff0000"
      end
    end

    describe "#nsfw" do
      it "returns the correct user NSFW preference" do
        user.nsfw.should eql true
      end
    end

    describe "#hash" do
      it "returns the correct user e-mail MD5 hash" do
        user.hash.should eql "6e8e0bf6135471802a63a17c5e74ddc5"
      end
    end
  end

  describe "#can_talk" do
    let(:user) { Chat::User.new 2, "Dummy", "dummy@example.com", 1, "ff0000", true }

    context "user is muted" do
      before do
        user.mute!
      end

      it "doesn't let the user talk when muted" do
        user.can_talk?.should be_false
      end

      after do
        user.unmute!
      end
    end

    context "user is not muted" do
      it "lets the user talk when not muted" do
        user.can_talk?.should be_true
      end
    end

    context "user is banned" do
      before do
        @redis.set "ban:2", true
      end

      it "doesn't let the user talk when banned" do
        user.can_talk?.should be_false
      end

      after do 
        @redis.del "ban:2"
      end
    end
  end
end