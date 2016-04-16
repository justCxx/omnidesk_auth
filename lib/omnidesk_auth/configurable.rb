module OmnideskAuth
  module Configurable
    attr_accessor :endpoint, :secret, :expire

    class << self
      def keys
        @keys ||= [:endpoint, :secret, :expire]
      end
    end

    def configure
      yield self
    end

    def reset!
      OmnideskAuth::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", OmnideskAuth::Default.options[key])
      end
      self
    end
    alias setup reset!

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
