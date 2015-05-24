module Superstructure
  class AttributeParser
    attr_reader :attributes

    def initialize(arguments, opts)
      @attributes = {}
      @possible_error = ArgumentErrorBuilder.new
      @arguments = arguments
      @opts = opts

      parse!
    end

    def error?
      @possible_error.error?
    end

    def error
      @possible_error.build
    end

    private

    def parse!
      used_params = []

      @arguments.each do |argument|
        if @opts.has_key?(argument) && @opts.has_key?(argument.to_s)
          @possible_error.add_error(:shadowed_params, argument)
          used_params << argument << argument.to_s
        elsif @opts.has_key?(argument)
          @attributes[argument] = @opts[argument]
          used_params << argument
        elsif @opts.has_key?(argument.to_s)
          @attributes[argument] = @opts[argument.to_s]
          used_params << argument.to_s
        else
          @possible_error.add_error(:missing_params, argument)
        end
      end

      @possible_error.add_errors(:extra_params, @opts.keys - used_params)
    end
  end
end
