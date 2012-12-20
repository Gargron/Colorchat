require 'spec_helper'

describe Chat::List do
  let(:list) { Chat::List.new }

  let(:user) { Chat::User.new 2, "Dummy", "dummy@example.com", 1, "ff0000", true }

  describe "#initialize" do
    it "creates new instance of List" do
      list.should be_instance_of Chat::List
    end

    it "creates an empty users array" do
      list.users.should be_empty
    end
  end

  context "users and sockets" do
    before :all do
      list.add(user, {})
    end

    describe "#add" do
      it "adds the user and the socket to the user list" do
        list.users.length.should eql 1
      end
    end

    describe "#find" do
      it "retrieves the user inside a hash" do
        list.find(2).should have_key :user
      end

      it "retrieves the user correctly" do
        list.find(2)[:user].should eql user
      end

      it "retrieves the sockets in the hash" do
        list.find(2).should have_key :sockets
      end
    end

    describe "#remove" do

    end
  end
end