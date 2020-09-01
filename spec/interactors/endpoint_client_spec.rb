# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndpointClient do
  let(:endpoint) { FactoryBot.create(:endpoint) }
  let(:endpoint_client) { EndpointClient.new(endpoint) }
  before(:each) do
    stub_request(:any, "https://api.github.com/test/1").to_return(status: 200, body: {'error': 'AnError'}.to_json, headers: { content_type: 'application/json; charset=utf-8' })
    stub_request(:any, "https://api.github.com/test/2").to_return(status: 500, body: "something", headers: {})
    stub_request(:any, "https://api.github.com/test/3").to_return(status: 200, body: "something", headers: {})
  end

  describe '#request' do 
    context 'when a perfect endpoint is used' do
      it 'should return with expected body' do
        expect(endpoint_client.request({things: '3'}).body).to eq('something')
      end
    end

    context 'when an invalid endpoint is used' do
      it 'should return 500 response status' do
        expect(endpoint_client.request({things: '2'}).status).to eq(500)
      end
    end

    context 'when invalid data is supplied to the application' do
      it 'should return error string containing error data' do
        expect(endpoint_client.request({things: '1'}).body['error']).to eq('AnError')
      end
    end
  end
end
