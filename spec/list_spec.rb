require 'spec_helper'

describe Chat::List do
  let(:list)  { Chat::List.new }
  let(:user1) { Chat::User.new 2, "Dummy", "dummy@example.com", 1, "ff0000", true }
  let(:user2) { Chat::User.new 1, "Joe", "joe@example.com", 1, "0000ff", false }
  let(:connection) { Hash.new }

  describe "#initialize" do
    it "creates new instance of List" do
      list.should be_instance_of Chat::List
    end

    it "creates an empty users array" do
      list.users.should be_empty
    end
  end

  context "users and connections" do
    before :all do
      list.add(user1, connection)
    end

    describe "#add" do
      it "adds the user and the connection to the user list" do
        list.users.length.should eql 1
      end
    end

    describe "#find" do
      it "retrieves the user inside a hash" do
        list.find(2).should have_key :user
      end

      it "retrieves the user correctly" do
        list.find(2)[:user].should eql user1
      end

      it "retrieves the connections in the hash" do
        list.find(2).should have_key :connections
      end
    end

    describe "#remove" do
      before do
        list.remove(user1.id, connection)
      end

      it "removes the user entry completely" do
        list.find(2).should be_nil
      end
    end
  end

  context "more users" do
    before :all do
      list.add(user1, connection)
      list.add(user2, connection)
    end

    describe "#add" do
      it "has two different users in the list" do
        list.users.length.should eql 2
      end
    end
  end
end
