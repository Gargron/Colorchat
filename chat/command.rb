module Chat
  module Command
    def self.ping(message, *args)
      "pong"
    end

    def self.mute(message, name, duration, *args)
      return "Insufficient rights" if message.user.role < 2
      "OK muting"
    end

    def self.unmute(message, name)
      return "Insufficient rights" if message.user.role < 2
      "OK unmuting"
    end
  end
end