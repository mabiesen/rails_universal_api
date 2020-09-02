# frozen_string_literal: true

class EndpointClient
  attr_accessor :request_method_symbol
  attr_accessor :client

  def initialize(endpoint)
    @request_method_symbol = endpoint.request_method.to_sym
    @client = endpoint.client
  end

  def request(url_path, extra_params)
    @client.send(@request_method_symbol) do |req|
      req.url url_path, extra_params
      req.headers['Content-Type'] = 'application/json'
    end
  end

end
