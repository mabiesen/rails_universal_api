# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndpointRequestBuilder do
  let(:endpoint) { FactoryBot.create(:endpoint, url_path: '/v1/stuff/:things', params: {things: {optional: false, type: 'Date'}, stuff: {optional:false, type: 'Date'}}) }
  let(:builder) { EndpointRequestBuilder.new(endpoint)  }


  describe '#validate' do
    context 'when field data supplied cannot be coerced to parameter type' do
      context 'when supplied data is a hash' do
        it 'should raise an error' do
          expect{ builder.validate({things: 'stuff', stuff: 'stuff'}) }.to raise_error(/is not a valid/)
        end
      end
    end

    context 'when field data is not optional and there is no data supplied' do
      context 'when supplied data is a hash' do
        it 'should raise an error' do
          expect{ builder.validate({things: '2020-09-23'}) }.to raise_error(/is not optional/)
        end
      end
    end

    context 'when perfect' do
      context 'when supplied data is hash' do
        it 'should not raise errors' do
          expect{ builder.validate({things: '2020-02-04', stuff: '2020-10-29'}) }.not_to raise_error
        end
      end
    end
  end

  describe '#formatted_url_path' do
    context 'when supplied a hash of data' do
      it 'returns the interpolated url_path' do
        data_hash = {things: '2020-02-04', stuff: '2020-10-29'}
        formatted_url_path = builder.formatted_url_path(data_hash)
        expect(formatted_url_path).to include(data_hash[:things])
        expect(formatted_url_path).not_to include(':things')
        expect(formatted_url_path).to include('stuff')
      end
    end
  end

  describe '#extra_params' do
    context 'when supplied a hash of data equalling number of url variables' do
      it 'returns an empty hash' do
        extra_params = builder.extra_params({things: '2020-02-04'})
        expect(extra_params).to be_a(Hash)
        expect(extra_params).to be_empty
      end
    end

    context 'when supplied an array of data with count greater than url variable count' do
      it 'returns hash containing data converted to param type' do
        extra_params = builder.extra_params({stuff: '2020-02-04', things: '2020-10-29'})
        expect(extra_params).to be_a(Hash)
        expect(extra_params['stuff']).to eq('2020-02-04')
      end
    end

  end
end
