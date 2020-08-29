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
      it 'should return json output for called entity' do

      end
    end

    context 'when called with error' do
      it 'should return json output indicating error' do
        
      end
    end
  end
end
