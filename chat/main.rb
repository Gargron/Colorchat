module Chat
  class Main
    # Public: The main room
    attr_accessor :root_room

    # Public: Users
    attr_accessor :list

    # Public: Initialize a new chat
    def initialize
      @root_room = Chat::Room.new "main"
      @list      = Chat::List.new self
    end
  end
end
