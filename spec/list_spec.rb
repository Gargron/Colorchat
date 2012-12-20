require 'spec_helper'

describe Chat::List do
  let(:list) { Chat::List.new }

  describe "#initialize" do
    it "creates new instance of List" do
      list.should be_instance_of Chat::List
    end

    it "creates an empty users array" do
      list.users.should be_intance_of Array
    end
  end
end