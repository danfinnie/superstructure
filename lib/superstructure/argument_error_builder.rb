module Superstructure
  class ArgumentErrorBuilder
    def initialize
      @errors = {
        extra_params: [],
        missing_params: [],
        shadowed_params: []
      }
    end

    def add_error(type, key)
      add_errors(type, [key])
    end

    def add_errors(type, key)
      @errors.fetch(type).concat(key)
    end

    def build
      ArgumentError.new(@errors)
    end

    def error?
      @errors.any? { |k, v| v.any? }
    end
  end
end
