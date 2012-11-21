module Chat
  class Message
    # Public: Returns type of message
    attr_reader :type

    # Public: Returns content of message
    attr_reader :text

    # Public: Returns owner of message
    attr_reader :user

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
      @executable = @text.start_with?("/") && Command.respond_to?(command)
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
      @text = Command::send(command, *(arguments.unshift self)) rescue ArgumentError "Argument error"
    end

    private

    # Internal: Get the command method from the message
    #
    # Returns string
    def command
      @text.split(" ").first.sub! "/", ""
    end

    # Internal: Get the command arguments from the message
    #
    # Returns the array of arguments
    def arguments
      args = @text.split(" ")
      args.shift
      args
    end
  end
end