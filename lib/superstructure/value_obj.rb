module Superstructure
  class ValueObj
    class << self
      def new *arguments, superclass: Object, &blk
        Class.new(superclass) do
          attr_reader :to_hash

          define_method(:initialize) do |opts={}|
            attributes = {}
            missing_params = []
            shadowed_params = []
            used_params = []

            arguments.each do |argument|
              if opts.has_key?(argument) && opts.has_key?(argument.to_s)
                shadowed_params << argument
                used_params << argument << argument.to_s

              elsif opts.has_key?(argument)
                attributes[argument] = opts[argument]
                used_params << argument
              elsif opts.has_key?(argument.to_s)
                attributes[argument] = opts[argument.to_s]
                used_params << argument.to_s
              else
                missing_params << argument
              end
            end

            extra_params = opts.keys - used_params

            if missing_params.any? || shadowed_params.any? || extra_params.any?
              raise ArgumentError.new(
                missing_params: missing_params,
                shadowed_params: shadowed_params,
                extra_params: extra_params
              )
            end

            @to_hash = attributes
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
