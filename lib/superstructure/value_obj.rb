module Superstructure
  class ValueObj
    class << self
      def new *arguments
        Class.new do
          attr_reader :to_hash

          def initialize(to_hash={})
            @to_hash = to_hash
          end

          define_method(:inspect) do
            opts = arguments.map do |argument|
              "#{argument}=#{public_send(argument).inspect}"
            end.join(", ")
            "#<value_obj #{self.class} #{opts}>"
          end

          arguments.each do |argument|
            define_method(argument) do
              to_hash[argument]
            end
          end
        end
      end
    end
  end
end
