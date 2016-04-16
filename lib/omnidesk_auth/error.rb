module OmnideskAuth
  class Error < StandardError
  end

  class ResponseError < Error
    def initialize(response = nil)
      @response = response
      super(build_error_message)
    end

    def build_error_message
      return if @response.nil?
      "#{@response.uri}: #{@response.code}"
    end
  end
end
