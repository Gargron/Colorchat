module Chat
  class Room < ::EventMachine::Channel
    # Public: Name of the room
    attr_reader :identifier

    # Public: Nested rooms
    attr_reader :children

    # Public: Reference to the parent room
    attr_reader :parent

    # Public: Initialize a new room
    #
    # identifier - name of the room
    # parent     - parent room (default: nil)
    def initialize(identifier, parent = nil)
      @identifier = identifier
      @parent     = parent
      @children   = Hash.new
      super()
    end

    # Public: Change parent
    #
    # parent - parent room
    #
    # Returns nothing
    def attribute_to(parent)
      @parent = parent
    end

    # Public: Create a nested room
    #
    # room
    #
    # Returns nothing
    def append(room)
      @children[room.identifier] = room
      room.attribute_to(self)
    end

    # Public: Resolve a room from a path
    #
    # path - Path to the room by room identifiers
    #
    # Returns a Room
    def get(path)
      identifiers = path.split(".")
      room        = self

      identifiers.each do |identifier|
        break if room.children[identifier].nil?
        room = room.children[identifier]
      end

      room
    end

    # Public: Broadcast data to this room and all its nested rooms
    #
    # data - Something to broadcast
    #
    # Returns nothing
    def shout(data)
      push data

      @children.each do |room|
        room.shout data
      end
    end

    # Public: Get recursive Hash of the room structure
    # 
    # Returns Hash
    def tree
      children = []
      
      @children.each do |room|
        children << room.tree
      end

      { @identifier => children }
    end

    # Public: JSON representation of the tree structure of the room and 
    # its children
    # 
    # Returns JSON string
    def to_json
      tree.to_json
    end
  end
end
