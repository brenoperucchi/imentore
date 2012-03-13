module SentientStore
  
  def self.included(base)
    base.class_eval {
      def self.current
        Thread.current[:store]
      end

      def self.current=(o)
        raise(ArgumentError,
            "Expected an object of class '#{self}', got #{o.inspect}") unless (o.is_a?(self) || o.nil?)
        Thread.current[:store] = o
      end
  
      def make_current
        Thread.current[:store] = self
      end

      def current?
        !Thread.current[:store].nil? && self.id == Thread.current[:store].id
      end
    }
  end
end
