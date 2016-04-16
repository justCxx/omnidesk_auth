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

    def inspect
      super.tap do |inspected|
        inspected.gsub! secret, "#{secret[0..4]}..." if secret
      end
    end

    def sso_auth_url(options = {})
      url_from_response_body(access_url(options))
    end

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

    private

    def url_from_response_body(url)
      response = Net::HTTP.get_response(url)
      return response.body if response.code.to_i == 200
      raise OmnideskAuth::ResponseError, response
    end
  end
end
