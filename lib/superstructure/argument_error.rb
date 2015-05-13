module Superstructure
  ArgumentError = ValueObj.new(
    :extra_params,
    :missing_params,
    :shadowed_params,
    superclass: ::ArgumentError
  ) do
    def message
      [
        extra_params.any? ? "Received unexpected options: #{extra_params.inspect}" : nil,
        missing_params.any? ? "Expected but did not receive: #{missing_params.inspect}" : nil,
        shadowed_params.any? ? "Received a symbol and string version of: #{shadowed_params.inspect}" : nil
      ].compact.join("\n")
    end
  end
end
