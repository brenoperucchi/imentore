module Imentore
  class Notification
    attr_accessor :message, :kind

    def initialize args
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end

    def errors?
      kind == "error"
    end
    
    def valid?
      kind == "success" or kind == "true"
    end
  end
end