module Chat
  class List
    # Public: The array that stores the users together with their sockets
    attr_reader :users

    # Public: Create a new list
    def initialize
      @users = []
    end

    # Public: Add a user to the list and their socket too
    # If a user is already in the list, add the socket
    #
    # user   - User
    # socket - Connection
    #
    # Returns nothing
    def add(user, socket)
    end

    # Public: Remove socket of user from the list, remove
    # user if no sockets are left
    #
    # id     - User ID
    # socket - Connection
    #
    # Returns nothing
    def remove(id, socket)
    end

    # Public: Find a user and their sockets
    #
    # id - User ID
    #
    # Returns hash with user and sockets
    def find(id)
    end
  end
end