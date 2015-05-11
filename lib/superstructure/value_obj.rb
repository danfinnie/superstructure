module Superstructure
  class ValueObj
    class << self
      def new *arguments
        Class.new do
          attr_reader :to_hash

          def initialize(opts={})
            @to_hash = opts.inject({}) do |memo, (key, value)|
              memo[key.intern] = value
              memo
            end
          end

          def inspect
            opts = to_hash.map do |opt_and_value|
              opt_and_value.join("=")
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
