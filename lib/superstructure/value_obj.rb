module Superstructure
  class ValueObj
    class << self
      def new *arguments, superclass: Object, &blk
        Class.new(superclass) do
          attr_reader :to_hash

          def initialize(opts={})
            @to_hash = opts.inject({}) do |memo, (key, value)|
              memo[key.intern] = value
              memo
            end
          end

          def inspect
            opts = to_hash.map do |k, v|
              "#{k}=#{v.inspect}"
            end.join(", ")
            "#<value_obj #{self.class} #{opts}>"
          end

          def ==(o)
            self.class == o.class && to_hash == o.to_hash
          end

          alias :eql? :==

          arguments.each do |argument|
            define_method(argument) do
              to_hash[argument]
            end
          end

          class_eval(&blk) if blk
        end
      end
    end
  end
end
