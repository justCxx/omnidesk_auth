require 'omnidesk_auth/configurable'
require 'omnidesk_auth/error'
require 'jwt'

module OmnideskAuth
  class Client
    include OmnideskAuth::Configurable

    def initialize(options = {})
      OmnideskAuth::Configurable.keys.each do |key|
        value = options[key] || OmnideskAuth.instance_variable_get(:"@#{key}")
        instance_variable_set(:"@#{key}", value)
      end
    end

    # Text representation of the client, masking secret
    # @return [String]
    def inspect
      super.tap do |inspected|
        inspected.gsub! secret, "#{secret[0..4]}..." if secret
      end
    end

    # Return SSO auth url
    # @param [Hash] options the options to create a message with.
    # @option options [Fixnum] :iat The subject
    # @option options [String] :email
    # @option options [String] :name
    # @option options [Fixnum] :external_id
    # @option options [String] :company_name
    # @option options [String] :company_position
    # @option options [String] :remote_photo_url
    # @option options [Fixnum] :exp
    # @see https://support.omnidesk.ru/knowledge_base/item/54180
    # @return [String]
    def sso_auth_url(options = {})
      url_from_response_body(access_url(options))
    end

    protected

    def access_url(options = {})
      payload = jwt_payload(options)
      URI.parse("#{base_url}?jwt=#{payload}")
    end

    def base_url
      return unless endpoint
      @base_url ||= URI.join(endpoint, 'access/jwt')
    end

    def jwt_payload(options = {})
      return unless secret
      JWT.encode(payload(options), secret)
    end

    def payload(options = {})
      payload = options.select { |k, _| payload_keys.include?(k) }

      payload[:iat] ||= Time.now.to_i
      payload[:exp] ||= expire if expire
      payload[:exp] += payload[:iat] if payload[:exp]

      payload
    end

    def payload_keys
      @payload_keys ||=
        [:iat,
         :email,
         :name,
         :external_id,
         :company_name,
         :company_position,
         :remote_photo_url,
         :exp]
    end

    def url_from_response_body(url)
      response = Net::HTTP.get_response(url)
      return response.body if response.code.to_i == 200
      raise OmnideskAuth::ResponseError, response
    end
  end
end
