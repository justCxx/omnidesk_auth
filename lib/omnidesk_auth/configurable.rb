# @!attribute endpoint
#   @return [String] Base URL for auth requests
# @!attribute expire
#   @return [Fixnum] Expire session time
# @!attribute secret
#   @return [String] JWT access token for authentication
module OmnideskAuth
  # Configuration options for {Client}, defaulting to values in {Default}
  module Configurable
    attr_accessor :endpoint, :secret, :expire

    class << self
      # List of configurable keys for {OmnideskAuth::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [:endpoint, :secret, :expire]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      OmnideskAuth::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", OmnideskAuth::Default.options[key])
      end
      self
    end
    alias setup reset!

    # Compares client options to a Hash of requested options
    # @param opts [Hash] Options to compare with current client options
    # @return [Boolean]
    def same_options?(opts)
      opts.hash == options.hash
    end

    private

    def options
      OmnideskAuth::Configurable.keys.each_with_object({}) do |key, hash|
        hash[key] = instance_variable_get(:"@#{key}")
      end
    end
  end
end
