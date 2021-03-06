module Chat
  module Command
    # Public: Say pong
    # 
    # Returns pong
    def self.ping(message, *args)
      "pong"
    end

    # Public: Load user from session
    # 
    # Returns status
    def self.auth(message, key, *args)
      begin
        Fiber.new do
          message.user.load key
        end.resume

        message.chat.list.add(message.user, message.connection)
        "OK authenticated"
      rescue Exception => err
        "Could not authenticate: #{err}"
      end
    end

    # Public: Mute a user
    # 
    # Returns status
    def self.mute(message, id, duration, *args)
      return "Insufficient rights" if message.user.role < 2

      Fiber.new do
        message.chat.list.find(id)[:user].mute!
      end.resume
      
      "OK muting"
    end

    # Public: Remove a mute on a user
    # 
    # Returns status
    def self.unmute(message, id, *args)
      return "Insufficient rights" if message.user.role < 2

      Fiber.new do
        message.chat.list.find(id)[:user].unmute!
      end.resume

      "OK unmuting"
    end

    # Public: List all online/connected users and the rooms they're in
    # 
    # Returns JSON string
    def self.list(message, *args)
      message.chat.list.to_json
    end

    # Public: List rooms
    # 
    # Returns JSON string
    def self.rooms(message, *args)
      message.chat.root_room.to_json
    end

    # Public: Transform something into a third-person thing
    # 
    # Returns tranformed string
    def self.me(message, *words)
      message.type = :system
      "#{message.user.name} #{words.join(' ')}"
    end

    # Public: Change the room of the connection
    # 
    # Returns status
    def self.enter(message, identifier, *args)
      message.connection.change_room identifier
      "Switched to room #{identifier}"
    end

    # Public: List possible commands
    # 
    # Returns commands
    def self.help(message, *args)
      Command.singleton_methods.join(' ')
    end
  end
end
