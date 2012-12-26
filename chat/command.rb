module Chat
  module Command
    def self.ping(message, *args)
      "pong"
    end

    def self.auth(message, key, *args)
      begin
        message.user.load key
        "OK authenticated"
      rescue Exception => err
        "Could not authenticate: #{err}"
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
      message.chat.list.to_json
    end
  end
end
