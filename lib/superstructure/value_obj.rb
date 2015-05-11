module Superstructure
  class ValueObj
    class << self
      def new *arguments
        Class.new do
          attr_reader *arguments

          define_method(:initialize) do |opts|
            opts.each do |(opt, value)|
              instance_variable_set("@#{opt}", value)
            end
          end

          define_method(:inspect) do
            opts = arguments.map do |argument|
              "#{argument}=#{public_send(argument).inspect}"
            end.join(", ")
            "#<value_obj #{self.class} #{opts}>"
          end
        end
      end
    end
  end
end
