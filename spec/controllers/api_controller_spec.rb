# frozen_string_literal: true

require 'rails_helper'

describe ApiController, type: :controller do

  describe '#list_endpoints' do
    context 'when called' do
      it 'should return json containing all available endpoints' do
        get "list_endpoints"
        expect(response.status).to eq(200)
        expect(response.body).to eq(Endpoint.all.to_json)
      end
    end
  end

  describe '#call' do
    context 'when called' do
      let (:good_response) { Struct.new(:status, :body).new(350, 'some_json') }
      let (:params) { { client_tag: 'github',
                        request_name: 'get_pull_requests',
                        arguments: ['mabiesen','universal_rails_api','closed']} }
      it 'should return json output for called entity' do
        allow_any_instance_of(ApiController).to receive(:make_request).and_return( good_response )
        post "call", params: params
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['status']).to eq(350)
        expect(JSON.parse(response.body)['body']).to eq('some_json')
      end
    end

    context 'when endpoint cannot be found' do
      it 'should raise error that endpoint was not found' do
        post "call", params: {client_tag: 'dolittle', request_name: 'nothin'} 
        expect(response.status).to eq(404) 
      end
    end
  end
end
