module Chat
  module Command
    def self.ping(message, *args)
      "pong"
    end

    def self.mute(message, name, duration, *args)
      "Insufficient rights" if message.user.role < 2
      "OK muting"
    end

    def self.unmute(message, name)
      "Insufficient rights" if message.user.role < 2
      "OK unmuting"
    end
  end
end