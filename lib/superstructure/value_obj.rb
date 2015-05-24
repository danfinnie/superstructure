module Superstructure
  class ValueObj
    class << self
      def new *arguments, superclass: Object, &blk
        Class.new(superclass) do
          define_method(:initialize) do |opts={}|
            @attributes = {}
            used_params = []
            possible_error = ArgumentErrorBuilder.new

            arguments.each do |argument|
              if opts.has_key?(argument) && opts.has_key?(argument.to_s)
                possible_error.add_error(:shadowed_params, argument)
                used_params << argument << argument.to_s
              elsif opts.has_key?(argument)
                @attributes[argument] = opts[argument]
                used_params << argument
              elsif opts.has_key?(argument.to_s)
                @attributes[argument] = opts[argument.to_s]
                used_params << argument.to_s
              else
                possible_error.add_error(:missing_params, argument)
              end
            end

            possible_error.add_errors(:extra_params, opts.keys - used_params)

            if possible_error.error?
              raise possible_error.build
            end
          end

          def to_hash
            @attributes.clone
          end

          def inspect
            opts = @attributes.map do |k, v|
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
