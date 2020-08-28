# frozen_string_literal: true

class EndpointClient
  attr_accessor :client

  def initialize(client)
    @client = client
  end

  def get(url_path, extra_params = {})
    request(:get, url_path, extra_params)
  end

  def post(url_path, extra_params = {})
    request(:post, url_path, extra_params)
  end

  def put(url_path, extra_params = {})
    request(:put, url_path, extra_params)
  end

  private

  def request(method_symbol, url_path, extra_params)
    @client.send(method_symbol) do |req|
      set_body(req, extra_params)
    end
  end

  def set_body(client_request, extra_params)
    client_request.body = extra_params.to_json
  end

end
