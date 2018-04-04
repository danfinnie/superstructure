module Superstructure
  class ValueObj
    class << self
      def new *arguments, superclass: Object, &blk
        Class.new(superclass) do
          define_singleton_method(:with_added_fields) do |*fields|
            ValueObj.new(*(arguments + fields), superclass: superclass, &blk)
          end

          define_method(:initialize) do |opts={}|
            attribute_parser = AttributeParser.new(arguments, opts)
            if attribute_parser.error?
              raise attribute_parser.error
            else
              @attributes = attribute_parser.attributes
            end
          end

          def to_hash
            @attributes.clone
          end

          def inspect
            opts = @attributes.map do |k, v|
              "#{k}=#{v.inspect}"
            end.join(", ")

            unless opts.empty?
              opts.prepend(" ")
            end

            "#<value_obj #{self.class}#{opts}>"
          end

          def ==(o)
            self.class == o.class && to_hash == o.to_hash
          end

          alias :eql? :==

          def hash
            self.class.hash ^ @attributes.hash
          end

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
