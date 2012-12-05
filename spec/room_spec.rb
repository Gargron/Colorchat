require 'spec_helper'

describe Chat::Room do
  let(:room) { Chat::Room.new "" }

  describe "#initialize" do
    it "initializes empty new room" do
      room.should be_instance_of Chat::Room
    end

    it "creates an empty nested rooms hash" do
      room.children.should be_instance_of Hash
    end

    it "has a name" do
      room.identifier.should eql ""
    end

    it "doesn't have a parent" do
      room.parent.should be_nil
    end
  end

  context "child rooms" do
    let(:child_room) { Chat::Room.new("test", room) }
    let(:even_childer_room) { Chat::Room.new("whoop", child_room) }

    before do
      room.append child_room
      child_room.append even_childer_room
    end

    describe "#append" do
      it "has a child room" do
        room.children["test"].should eql child_room
      end
    end

    describe "#get" do
      it "resolves to the child room" do
        room.get("test").should eql child_room
      end

      it "resolves to the nested nested room" do
        room.get("test.whoop").should eql even_childer_room
      end
    end
  end
end
