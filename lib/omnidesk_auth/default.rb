module OmnideskAuth
  module Default
    class << self
      # Configuration options
      # @return [Hash]
      def options
        Hash[OmnideskAuth::Configurable.keys.map { |key| [key, send(key)] }]
      end

      # Default auth endpoint from ENV
      # @return [String] endpoint url
      def endpoint
        ENV['OMNIDESK_AUTH_ENDPOINT']
      end

      # Default auth secret from ENV
      # @return [String]
      def secret
        ENV['OMNIDESK_AUTH_SECRET']
      end

      # Default expire session time from ENV
      # @return [Fixnum] expire session time
      def expire
        ENV['OMNIDESK_AUTH_EXPIRE'].to_i
      end
    end
  end
end
