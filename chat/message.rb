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

    # Public: Convert to a JSON object
    #
    # Returns the JSON string
    def to_json
      hash = {}
      self.instance_variables.each {|var| hash[var.to_s.delete "@"] = self.instance_variable_get var }
      hash.to_json
    end
  end
end