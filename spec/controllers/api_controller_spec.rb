# frozen_string_literal: true

require 'rails_helper'

describe ApiController, type: :controller do
  let(:github_endpoint ) { FactoryBot.create(:endpoint) }

  before(:each) do
    github_endpoint.save!
  end

  describe '#list_endpoints' do
    context 'when called' do
      it 'should return json containing all available endpoints' do
        get "list_endpoints"
        expect(response.status).to eq(200)
        expect(response.body).to eq(Endpoint.all.to_json)
      end
    end
    
    context 'when called with parameters' do
      it 'should filter endpoints' do
        post "list_endpoints", params: {client_tag: github_endpoint.client_tag}
        body = JSON.parse(response.body)
        client_tags = body.map{|x| x['client_tag']}.uniq
        expect(client_tags.count).to eq(1)
        expect(client_tags.first).to eq('github')
      end
    end
  end

  describe '#call' do
    context 'when called' do
      let (:good_response) { [{'real': 2.7}, Struct.new(:status, :body).new(350, 'some_json')] }
      let (:params) { { client_tag: 'github',
                        request_name: 'test',
                        owner: 'mabiesen',
                        repo: 'universal_rails_api',
                        state: 'closed'} }
      it 'should return json' do 
        allow_any_instance_of(ApiController).to receive(:make_benchmarked_request).and_return( good_response )
        post "call", params: params
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['status']).to eq(350)
        expect(parsed_body['body']).to eq('some_json')
        expect{ Float(parsed_body['benchmark']['real'])}.not_to raise_error
        expect(Float(parsed_body['benchmark']['real'])).not_to eq(0)
      end
    end

    context 'when endpoint cannot be found' do
      it 'should return 404 status' do
        post "call", params: {client_tag: 'dolittle', request_name: 'nothin'} 
        expect(response.status).to eq(404) 
      end
    end

    context 'when request error occurs' do
      it 'should return 500 status' do
        allow_any_instance_of(ApiController).to receive(:make_benchmarked_request).and_raise( 'custom error' )
        post "call", params: {client_tag: 'github', request_name: 'test', foo: 'bar'}
        expect(response.status).to eq(500)
        expect(JSON.parse(response.body)['error']).to eq('custom error')
      end
    end
  end

  describe '#validate_params' do
    context 'when called successfully' do
      let (:params) { { client_tag: 'github',
                      request_name: 'test',
                      things: 'mabiesen'} }
      it 'should return status 200' do
        post "validate_params", params: params
        puts "params response body #{response.body}"
        expect(response.status).to eq(200)
      end
    end

    context 'when request error occurs' do
      let (:params) { { client_tag: 'github',
                        request_name: 'test',
                        foo: 'bar' } }
      it 'should return 500 status' do
        post "validate_params", params: params
        puts "Response body #{response.body}"
        expect(response.status).to eq(500)
        expect(JSON.parse(response.body)['error']).not_to be(nil)
      end
    end

    context 'when endpoint cannot be found' do
      it 'should return 404 status' do
        post "validate_params", params: {client_tag: 'shenan', request_name: 'igans'}
        expect(response.status).to eq(404)
      end
    end
  end

  describe '#validate_param' do
    context 'when called successfully' do
      it 'should return 200 response' do
        post "validate_param", params: {client_tag: 'github', request_name: 'test', things: 'mabiesen'}
        expect(response.status).to eq(200)
      end
    end

    context 'when endpoint cannot be found' do
      it 'should return 404 status' do
        post "validate_param", params: {client_tag: 'shenan', request_name: 'igans'}
        expect(response.status).to eq(404)
      end
    end

    context 'when request error occurs' do
      it 'should return 500 status' do
        post "validate_param", params: {client_tag: 'github', request_name: 'test', foo: 'bar'}
        expect(response.status).to eq(500)
        expect(JSON.parse(response.body)['error']).not_to be(nil)
      end
    end
  end

end
