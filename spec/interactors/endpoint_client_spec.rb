# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndpointClient do
  let(:endpoint_client) { EndpointClient.new(GITHUB_CLIENT) }
  before(:each) do
    stub_request(:any, "https://api.github.com/bad/:data").to_return(status: 200, body: {'error': 'AnError'}.to_json, headers: { content_type: 'application/json; charset=utf-8' })
    stub_request(:any, "https://api.github.com/bad/:url").to_return(status: 500, body: "something", headers: {})
    stub_request(:any, "https://api.github.com/good/:request").to_return(status: 200, body: "something", headers: {})
  end

  describe '#post' do #post, get, etc are wrappers around the request method
    context 'when a perfect endpoint is used' do
      it 'should return nil body' do
        expect(endpoint_client.post('/good/:request', 1).body).to eq('something')
      end
    end

    context 'when an invalid endpoint is used' do
      it 'should return error string containing response status' do
        expect(endpoint_client.post('/bad/:url', 1).status).to eq(500)
      end
    end

    context 'when invalid data is supplied to the application' do
      it 'should return error string containing error data' do
        expect(endpoint_client.post('/bad/:data', 1).body['error']).to eq('AnError')
      end
    end
  end
end
