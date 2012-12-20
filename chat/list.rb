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
      found = find(user.id)

      if found.nil?
        @users << { :user => user, :sockets => [socket] }
      else
        @users[found[:index]][:sockets] << socket
      end
    end

    # Public: Remove socket of user from the list, remove
    # user if no sockets are left
    #
    # id     - User ID
    # socket - Connection
    #
    # Returns nothing
    def remove(id, socket)
      found = find(id)

      if found.nil?
        return
      else
        @users[found[:index]][:sockets].delete socket

        if @users[found[:index]][:sockets].empty?
          @users.delete_at found[:index]
        end
      end
    end

    # Public: Find a user and their sockets
    #
    # id - User ID
    #
    # Returns hash with user and sockets
    def find(id)
      index_at = -1
      entry    = nil

      @users.each_index do |i|
        if @users[i][:user].id == id
          index_at = i
          entry = @users[i]
          break
        end
      end

      unless entry.nil?
        entry[:index] = index_at
      end

      entry
    end
  end
end