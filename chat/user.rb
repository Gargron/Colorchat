module Chat
  # Public: Redis singleton call
  # 
  # Returns EM-Redis connection
  def self.redis
    @redis ||= EM::Protocols::Redis.connect
  end

  class User
    # Public: Returns the user ID
    attr_reader :id

    # Public: Returns the user name
    attr_reader :name

    # Public: Returns the the user e-mail
    attr_reader :email

    # Public: Returns the md5-hash of the user e-mail
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

    # Public: Update current instance by loading data from a datastore
    #
    # identifier - key for datastore look-up
    #
    # Returns nothing
    def load(identifier)
      user_hash = JSON.parse(redis("get", "user:session:#{identifier}"))
      raise "Given user is empty" if user_hash.nil?

      @id    = user_hash['id']
      @name  = user_hash['name']
      @email = user_hash['email']
      @hash  = Digest::MD5.hexdigest(user_hash['email'])
      @role  = user_hash['role']
      @color = user_hash['color']
      @nsfw  = user_hash['nsfw']
    end

    # Public: Mute the user
    #
    # Returns nothing
    def mute!
      redis("set", "chat:mute:#{@name}", true)
    end

    # Public: Remove the mute on the user
    #
    # Returns nothing
    def unmute!
      redis("del", "chat:mute:#{@name}")
    end

    # Public: Whether the user is allowed to talk right now
    #
    # Returns a boolean value
    def can_talk?
      muted  = !!redis("get", "chat:mute:#{@name}")
      banned = !!redis("get", "ban:#{@id}")

      !(muted || banned || @id == 0)
    end

    # Public: Transforms the instance of User into a simple hash object
    #
    # Returns a hash
    def to_hash
      {
        :id    => @id,
        :name  => @name,
        :email => @email,
        :hash  => @hash,
        :role  => @role,
        :color => @color,
        :nsfw  => @nsfw
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
    def redis(cmd, *args)
      fiber = Fiber.current
 
      Chat.redis.send(cmd, *args) do |response|
        fiber.resume response
      end
 
      Fiber.yield
    end
  end
end
