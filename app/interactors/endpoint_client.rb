# frozen_string_literal: true

class EndpointClient
  attr_accessor :request_method_symbol
  attr_accessor :client
  attr_accessor :endpoint_request_builder

  def initialize(endpoint)
    @request_method_symbol = endpoint.request_method
    @endpoint_request_builder = EndpointRequestBuilder.new(endpoint)
    @client = endpoint.client
  end

  def request(argument_array)
    url_path, extra_params = build_request(argument_array)
    @client.send(@request_method_symbol) do |req|
      req.url url_path, extra_params
      req.headers['Content-Type'] = 'application/json'
    end
  end

  private

  def build_request(argument_array)
    @endpoint_request_builder.validate(argument_array)
    url_path = @endpoint_request_builder.formatted_url_path(argument_array)
    extra_params = @endpoint_request_builder.extra_params(argument_array)
    [url_path, extra_params]
  end
end
