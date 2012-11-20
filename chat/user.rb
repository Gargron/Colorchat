module Chat
  class User
    # Public: Returns the user ID
    attr_reader :id

    # Public: Returns the user name
    attr_reader :name

    # Public: Returns the the user e-mail
    attr_reader :email

    # Public: Returns the md5-hash of the user e-mail
    # String
    attr_reader :hash

    # Public: Returns the user role
    attr_reader :role

    # Public: Returns the preset user color
    attr_reader :color

    # Public: Returns if the user wants to see NSFW content
    attr_reader :nsfw

    # Public: New instance of User from scratch
    #
    # id    - user ID
    # name  - user name
    # email - user e-mail
    # role  - user role
    # color - user preferred HEX color
    # nsfw  - user preferred NSFW setting on/off
    def initialize(id, name, email, role, color, nsfw)
      @id    = id
      @name  = name
      @email = email
      @hash  = Digest::MD5.hexdigest(email)
      @role  = role
      @color = color
      @nsfw  = nsfw
    end

    # Public: New instance of User from a datastore session identifier
    #
    # identifier - key for datastore look-up
    #
    # Returns an instance of User
    def self.from_datastore(identifier)
      user_hash = JSON.parse(redis("get", "user:session:#{identifier}"))
      raise "Given user is empty" if user_hash.nil?
      self.new user_hash['id'], user_hash['name'], user_hash['email'], user_hash['role'], user_hash['color'], user_hash['nsfw']
    end

    # Public: Mute the user
    #
    # Returns nothing
    def mute!
      self.class.redis("set", "chat:mute:#{@name}", true)
    end

    # Public: Remove the mute on the user
    #
    # Returns nothing
    def unmute!
      self.class.redis("del", "chat:mute:#{@name}")
    end

    # Public: Whether the user is allowed to talk right now
    #
    # Returns a boolean value
    def can_talk?
      muted  = !!self.class.redis("get", "chat:mute:#{@name}")
      banned = !!self.class.redis("get", "ban:#{@id}")

      !(muted || banned)
    end

    # Public: Transforms the instance of User into a simple hash object
    #
    # Returns a hash
    def to_hash
      {
        :id   => @id,
        :name => @name,
        :hash => @hash,
        :role => @role
      }
    end

    # Public: Transforms the instance of User into a JSON object
    #
    # Returns a JSON string
    def to_json
      to_hash.to_json
    end

    private

    # Internal: Communicate with the Redis datastore by executing a command
    #
    # cmd  - the redis command to execute
    # args - zero or more arguments for the redis command
    #
    # Returns redis response
    def self.redis(cmd, *args)
      redis  = Redis.new
      result = redis.send(cmd, *args)
      redis.quit
      result
    end
  end
end