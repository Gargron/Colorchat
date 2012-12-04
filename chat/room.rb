module Chat
  class Room < EventMachine::Channel
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

    # Public: Create a nested room
    #
    # room
    #
    # Returns nothing
    def append(room)
      @children[room.identifier] = room
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
        room = room.children[identifier]
      end

      room
    end
  end
end
