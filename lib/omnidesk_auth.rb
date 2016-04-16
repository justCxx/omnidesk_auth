require 'omnidesk_auth/client'
require 'omnidesk_auth/configurable'
require 'omnidesk_auth/default'
require 'omnidesk_auth/version'

module OmnideskAuth
  class << self
    include OmnideskAuth::Configurable

    def client
      return @client if defined?(@client) && @client.same_options?(options)
      @client = OmnideskAuth::Client.new(options)
    end

    private

    def respond_to_missing?(method_name, include_private = false)
      client.respond_to?(method_name, include_private)
    end

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end
  end
end

OmnideskAuth.setup
