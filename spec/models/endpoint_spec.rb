require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  let(:endpoint) { FactoryBot.create(:endpoint) }

  describe '#initialize' do
    context 'perfect endpoint supplied' do
      it 'should not raise error' do
        expect(FactoryBot.build(:endpoint)).to be_valid
      end
    end

    context 'when perfect endpoint supplied with body template' do
      it 'should not raise error' do
        body_template = {some_wrapper: { things: nil } }
        expect(FactoryBot.build(:endpoint, body_template: body_template)).to be_valid
      end
    end

    context 'URL_PATH does not start with forward slash' do
      it 'should raise error' do
        url_path = 'v1/stuff/:things'
        expect(FactoryBot.build(:endpoint, url_path: url_path)).to_not be_valid
      end
    end

    context 'URL_PATH ends in forward slash' do
      it 'should raise error on save' do
        url_path = '/v1/stuff/:things/'
        expect(FactoryBot.build(:endpoint, url_path: url_path)).to_not be_valid
      end
    end

    context "NAME contains spaces" do
      it 'should raise error' do
        name = 'issue all approved batch errors'
        expect(FactoryBot.build(:endpoint, name: name)).to_not be_valid
      end
    end

    context 'CLIENT_TAG is not a documented' do
      it 'should raise error' do
        client_tag = 'friggle_fraggle'
        expect(FactoryBot.build(:endpoint, client_tag: client_tag)).to_not be_valid
      end
    end

    context 'REQUEST_METHOD is not a put or post method' do
      it 'should raise error' do
        request_method = 'friggle_fraggle'
        expect(FactoryBot.build(:endpoint, request_method: request_method)).to_not be_valid
      end
    end

    context 'PARAMS do not include url variables' do
      it 'should raise error' do
        url_path = '/v1/stuff/:things'
        params = {stuff: {optional: false, type: 'String'}}
       expect(FactoryBot.build(:endpoint, url_path: url_path, params: params)).to_not be_valid
      end 
    end

    context 'Param value is not a hash' do
      it 'should raise error' do
        url_path = '/v1/stuff/:things'
        params = {things: 'dude'}
        expect(FactoryBot.build(:endpoint, url_path: url_path, params: params)).to_not be_valid
      end
    end

    context "Param does not have 'optional' key" do
      it 'should raise error' do
        url_path = '/v1/stuff/:things'
        params = {things: {type: 'String'}}
        expect(FactoryBot.build(:endpoint, url_path: url_path, params: params)).to_not be_valid
      end
    end

    context "Param optional argument is not boolean" do
      it 'should raise error' do
        url_path = '/v1/stuff/:things'
        params = {things: {type: 'String', optional: 'falllllse'}}
        expect(FactoryBot.build(:endpoint, url_path: url_path, params: params)).to_not be_valid
      end
    end

    context "Param does not have 'type' key" do
      it 'should error' do
        url_path = '/v1/stuff/:things'
        params = {things: {optional: false}}
        expect(FactoryBot.build(:endpoint, url_path: url_path, params: params)).to_not be_valid
      end
    end

    context 'Param type argument is not an accepted ruby class name'  do
      it 'should error' do
        url_path = '/v1/stuff/:things'
        params = {things: {optional: false, type: 'SomeWeirdObjectType'}}
        expect(FactoryBot.build(:endpoint, url_path: url_path, params: params) ).to_not be_valid
      end
    end

    context 'BODY TEMPLATE is not nil and does not contain all param keys' do
      it 'should error' do
        url_path = '/v1/stuff/:things'
        params = {matt: { optional: false, type: 'String' },
                  things: { optional: false, type: 'String' }}
        body_template = { wrapper: { something: 'default_value'}, things: 'hey' }
        expect(FactoryBot.build(:endpoint,
                                 url_path: url_path,
                                 params: params,
                                 body_template: body_template)).to_not be_valid
      end
    end

    context 'BODY TEMPLATE is not nil and contains duplicate keys' do
      it 'should error' do
        url_path = '/v1/stuff/:things'
        params = {matt: { optional: false, type: 'String' },
                  things: { optional: false, type: 'String' }}
        body_template = { wrapper: { matt: 'default_value'}, things: 'hey', matt: nil}
        expect(FactoryBot.build(:endpoint,
                                url_path: url_path,
                                params: params, 
                                body_template: body_template)).to_not be_valid
      end
    end
  end

  describe '#url_variables' do
    context 'when supplied url with 1 var' do
      it 'returns array of 1 item' do
        url_vars = endpoint.url_variables
        expect(url_vars.count).to eq(1)
      end
    end

    context 'when supplied url with 2 vars' do
      let(:two_var_endpoint) { FactoryBot.create(:endpoint, url_path: '/v1/:one/:two', params: { one: {type: 'String', optional: false}, two: {type: 'String', optional: false}}) }
      it 'returns array containing 2 items' do
        url_vars = two_var_endpoint.url_variables
        expect(url_vars.count).to eq(2)
      end
    end
  end

  describe '#client' do
    context 'when called with a client_tag that has been mapped to a client' do
      it 'returns client for the brand' do
        expect(endpoint.client).to be_a(Faraday::Connection)
      end
    end

    context 'when called with a client_tag that has not been mapped to a client' do
      it 'returns nil' do
        endpoint.client_tag = 'blah'
        expect(endpoint.client).to eq(nil)
      end
    end
  end
end
