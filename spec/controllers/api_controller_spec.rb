# frozen_string_literal: true

require 'rails_helper'

describe ApiController, type: :controller do

  describe '#list_endpoints' do
    context 'when called' do
      it 'should return json containing all available endpoints', :skip => 'fails in circleci only' do
        get "list_endpoints"
        expect(response.status).to eq(200)
        expect(response.body).to eq(Endpoint.all.to_json)
      end
    end
    
    context 'when called with parameters' do
        let(:github_endpoint ) { FactoruyBot.create(:endpoint, name: 'something') }
        let(:non_github_endpoint) { FactoryBot.create(:endpoint, client_tag: google, name: 'something_else') }
      it 'should filter endpoints' , :skip => 'fails in circleci only' do
        get "list_endpoints", params: {client_tag: 'github'}
        body = JSON.parse(response.body)
        client_tags = body.map{|x| x['client_tag']}.uniq
        expect(client_tags.count).to eq(1)
        expect(client_tags.first).to eq('github')
      end
    end
  end

  describe '#call' do
    context 'when called' do
      # TEST FAILING ON CIRCLECI
      # TEST PASSES LOCALLY
      let (:good_response) { Struct.new(:status, :body).new(350, 'some_json') }
      let (:params) { { client_tag: 'github',
                        request_name: 'get_pull_requests',
                        arguments: ['mabiesen','universal_rails_api','closed']} }
      it 'should return json', :skip => 'fails in circleci only' do 
        allow_any_instance_of(ApiController).to receive(:make_request).and_return( good_response )
        post "call", params: params
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
