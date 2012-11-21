module Chat
  class Message
    # Public: Returns type of message
    attr_reader :type

    # Public: Returns content of message
    attr_reader :text

    # Public: Returns owner of message
    attr_reader :user

    # Public: Known commands that can be invoked from the text
    KNOWN_METHODS = ["/ping"]

    # Public: Initializes a new message instance
    #
    # options - Hash options used to instantiate the message polymorphically
    #           :type - Type of the message
    #           :user - Owner of the message (optional)
    #           :text - The contents of the message
    def initialize(options)
      @type = options[:type]
      @text = options[:text]
      @user = options[:user]
    end

    # Public: Is the message for broadcast or for one client?
    #
    # Returns the boolean value
    def public?
      [:system, :text].include? @type
    end

    # Public: Transforms the instance of Message into a hash object
    #
    # Returns a hash
    def to_hash
      {
        :type => @type,
        :text => @text,
        :user => @user.nil? ? nil : @user.to_hash
      }
    end

    # Public: Converts message to a JSON object
    #
    # Returns the JSON string
    def to_json
      to_hash.to_json
    end

    # Public: Is message a command to be executed?
    #
    # Returns the boolean value, caches the result
    def executable?
      return @executable if !@executable.nil?

      starts_with_slash = @text.start_with? "/"
      known_command     = KNOWN_METHODS.include? @text.split(" ").first

      @executable = starts_with_slash && known_command
      @executable
    end

    # Public: Execute the command of the message, convert current message into
    # a response to the sender with the result of the command
    #
    # Returns nothing
    def execute!
      raise 'Message not executable' if !executable?

      @user = nil
      @type = :response
      @text = ""
    end
  end
end