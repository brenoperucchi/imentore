module EnumerateIt

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def associate_values(method, associates = {})
      associates.each {|name|
        define_method "#{name.to_s}?" do
          handle == name.to_s
        end
      }
    end
  end


end