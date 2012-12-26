module Chat
  class List
    # Public: The array that stores the users together with their connections
    attr_reader :users

    # Public: Create a new list
    def initialize
      @users = []
    end

    # Public: Add a user to the list and their connection too
    # If a user is already in the list, add the connection
    #
    # user       - User
    # connection - Connection
    #
    # Returns nothing
    def add(user, connection)
      found = find(user.id)

      puts "List#add, #{user.id}, #{found.inspect}"

      if found.nil?
        @users.push({ :user => user, :connections => [connection] })
      else
        @users[found[:index]][:connections].push connection
      end
    end

    # Public: Remove connection of user from the list, remove
    # user if no connections are left
    #
    # id         - User ID
    # connection - Connection
    #
    # Returns nothing
    def remove(id, connection)
      found = find(id)

      puts "List#remove, #{id}, #{found.inspect}"

      if found.nil?
        return
      else
        @users[found[:index]][:connections].delete connection

        if @users[found[:index]][:connections].empty?
          @users.delete_at found[:index]
        end
      end
    end

    # Public: Find a user and their connections
    #
    # id - User ID
    #
    # Returns hash with user and connections
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

    # Public: Return the user list as a JSON string
    #
    # Returns JSON string
    def to_json
      @users.map { |item|
        item[:user].to_hash.merge({ :rooms => item[:connections].map { |conn|
          conn.room.identifier
        } })
      }.to_json
    end
  end
end
