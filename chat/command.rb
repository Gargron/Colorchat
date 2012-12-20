module Chat
  module Command
    def self.ping(message, *args)
      "pong"
    end

    def self.auth(message, key, *args)
      begin
        message.user.load key
        "OK authenticated"
      rescue
        "Could not authenticate"
      end
    end

    def self.mute(message, name, duration, *args)
      return "Insufficient rights" if message.user.role < 2
      "OK muting"
    end

    def self.unmute(message, name, *args)
      return "Insufficient rights" if message.user.role < 2
      "OK unmuting"
    end

    def self.list(message, *args)
      message.chat.list.inspect
    end
  end
end