# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndpointClient do
  let(:endpoint) { FactoryBot.create(:endpoint) }
  let(:endpoint_client) { EndpointClient.new(endpoint) }
  let(:endpoint_request_builder) { EndpointRequestBuilder.new(endpoint) }
  before(:each) do
    stub_request(:any, "https://api.github.com/test/1").to_return(status: 200, body: {'error': 'AnError'}.to_json, headers: { content_type: 'application/json; charset=utf-8' })
    stub_request(:any, "https://api.github.com/test/2").to_return(status: 500, body: "something", headers: {})
    stub_request(:any, "https://api.github.com/test/3").to_return(status: 200, body: "something", headers: {})
  end

  describe '#request' do 
    context 'when a perfect endpoint is used' do
      it 'should return with expected body' do
        arguments = {things: '3'}
        url_path = endpoint_request_builder.formatted_url_path(arguments)
        extra_params = endpoint_request_builder.extra_params(arguments)
        expect(endpoint_client.request(url_path, extra_params).body).to eq('something')
      end
    end

    context 'when an invalid endpoint is used' do
      it 'should return 500 response status' do
        arguments = {things: '2'}
        url_path = endpoint_request_builder.formatted_url_path(arguments)
        extra_params = endpoint_request_builder.extra_params(arguments)
        expect(endpoint_client.request(url_path, extra_params).status).to eq(500)
      end
    end

    context 'when invalid data is supplied to the application' do
      it 'should return error string containing error data' do
        arguments = {things: '1'}
        url_path = endpoint_request_builder.formatted_url_path(arguments)
        extra_params = endpoint_request_builder.extra_params(arguments)
        expect(endpoint_client.request(url_path, extra_params).body['error']).to eq('AnError')
      end
    end
  end
end
