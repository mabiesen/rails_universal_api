# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndpointClient do
  let(:endpoint_client) { EndpointClient.new(GITHUB_CLIENT) }

  before(:each) do
    WebMock.stub_request(:any, "https://www.github.com/api/v3/things/:request").
      to_return(status: 200, body: "something", headers: {})

    WebMock.stub_request(:any, "https://www.github.com/api/v3/things/:url").
      to_return(status: 500, body: "something", headers: {})

    WebMock.stub_request(:any, "https://www.github.com/api/v3/things/:data").
      to_return(status: 200, body: {'error': 'AnError'}.to_json, headers: { content_type: 'application/json; charset=utf-8' })
  end

  describe '#post' do
    context 'when a perfect endpoint is used' do
      it 'should return nil' do
        expect(endpoint_client.post('/v1/good/:request', 'abatch', 1)).to be(nil)
      end
    end

    context 'when an invalid endpoint is used' do
      it 'should return error string containing response status' do
        expect(endpoint_client.post('/v1/bad/:url', 'abatch', 1)).to include('500')
      end
    end

    context 'when invalid data is supplied to the application' do
      it 'should return error string containing error data' do
        expect(endpoint_client.post('/v1/bad/:data', 'abatch', 1)).to include('AnError')
      end
    end
  end

  describe '#put' do
    context 'when a perfect endpoint is used' do
      it 'should return nil' do
        expect(endpoint_client.put('/v1/good/:request', 'abatch', 1)).to be(nil)
      end
    end

    context 'when an invalid endpoint is used' do
      it 'should return error string containing response status' do
        expect(endpoint_client.put('/v1/bad/:url', 'abatch', 1)).to include('500')
      end
    end

    context 'when invalid data is supplied to the application' do
      it 'should return error string containing error data' do
        expect(endpoint_client.put('/v1/bad/:data', 'abatch', 1)).to include('AnError')
      end
    end
  end

  describe '#get' do
    context 'when a perfect endpoint is used' do
      it 'should return nil' do
        expect(endpoint_client.get('/v1/good/:request', 'abatch', 1)).to be(nil)
      end
    end

    context 'when an invalid endpoint is used' do
      it 'should return error string containing response status' do
        expect(endpoint_client.get('/v1/bad/:url', 'abatch', 1)).to include('500')
      end
    end

    context 'when invalid data is supplied to the application' do
      it 'should return error string containing error data' do
        expect(endpoint_client.get('/v1/bad/:data', 'abatch', 1)).to include('AnError')
      end
    end
  end
end
