module OmnideskAuth
  module Default
    class << self
      def options
        Hash[OmnideskAuth::Configurable.keys.map { |key| [key, send(key)] }]
      end

      def endpoint
        ENV['OMNIDESK_AUTH_ENDPOINT']
      end

      def secret
        ENV['OMNIDESK_AUTH_SECRET']
      end

      def expire
        ENV['OMNIDESK_AUTH_EXPIRE']
      end
    end
  end
end
