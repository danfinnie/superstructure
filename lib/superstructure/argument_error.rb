module Superstructure
  ArgumentError = ValueObj.new(
    :extra_params,
    :missing_params,
    :shadowed_params,
    superclass: ::ArgumentError
  ) do
    def message
      inspect
    end
  end
end
