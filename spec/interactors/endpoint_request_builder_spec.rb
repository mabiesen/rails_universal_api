# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EndpointRequestBuilder do
  let(:endpoint) { FactoryBot.create(:endpoint, 
                                     url_path: '/v1/stuff/:things', 
                                     params: {things: {optional: false, type: 'Date'},
                                              stuff: {optional:false, type: 'Date'}}) }

  let(:builder) { EndpointRequestBuilder.new(endpoint)  }

  let(:test_data_hash) { { 'String' => 'a_string',
                           'Date' => '2020-12-27',
                           'Boolean' => 'true',
                           'Integer' => '209',
                           'Float' => '30.33'} }

  def change_param_type(endpoint, param_name, type)
    endpoint.params[param_name]['type'] = type
    endpoint.save!
  end

  describe '#validate' do
    context 'when supplied hash contains unincluded keys' do
      it 'should raise error' do
        expect{ builder.validate({owdner: 'stuff', stuff: 'stuff'}) }.to raise_error(/contains unidentified params/)
      end
    end

    context 'when field data supplied cannot be coerced to parameter type' do
      it 'should raise an error if provided value of another type' do
        transferrable_datatypes = ['Integer', 'Float']
        test_data_hash.each do |type, value|
          test_data_hash.each do |key, _|
            change_param_type(endpoint, 'things', key)
            builder = EndpointRequestBuilder.new(endpoint)
            if type == key || key == 'String' || (key == 'Float' && type == 'Integer') 
              expect{ builder.validate({things: value, stuff: '2020-11-23'}) }.not_to raise_error
            else
              expect{ builder.validate({things: value, stuff: '2020-11-23'}) }.to raise_error(/is not a valid/)
            end
          end
        end
      end
    end

    context 'when field data is not optional and there is no data supplied' do
      it 'should raise an error' do
        expect{ builder.validate({things: '2020-09-23'}) }.to raise_error(/is not optional/)
      end
    end

    context 'when perfect' do
      it 'should not raise errors' do
        expect{ builder.validate({things: '2020-02-04', stuff: '2020-10-29'}) }.not_to raise_error
      end
    end
  end

  describe '#validate_param' do
    context 'when called successfully' do
      it 'should not error' do
          expect{ builder.validate_param('things', '2020-02-04') }.not_to raise_error
      end
    end

    context 'when called with bad param_name' do
      it 'should raise error' do
          expect{ builder.validate_param('gerblesnarf', 'stuff') }.to raise_error(/does not exist for endpoint/)
      end
    end

    context 'when no value is supplied for a non-optional param' do
      it 'should raise error' do
          expect{ builder.validate_param('things', nil) }.to raise_error(/column is not optional/)
      end
    end

    context 'when data in a column cannot be coerced to type' do
      it 'should raise error' do
          expect{ builder.validate_param('things', 'blarney') }.to raise_error(/is not a valid/)
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

    it 'should return hash with stringified keys' do
      extra_params = builder.extra_params({things: '2020-02-04'})
      expect(extra_params).to be_a(Hash)
    end

    context 'when supplied a hash of data equalling number of url variables' do
      it 'returns an empty hash' do
        extra_params = builder.extra_params({things: '2020-02-04'})
        expect(extra_params).to be_a(Hash)
        expect(extra_params).to be_empty
      end
    end

    context 'when supplied hash contains nil values' do
      it 'returns hash with out nil values' do
        extra_params = builder.extra_params({things: nil, stuff: 'dude'})
        expect(extra_params).to eq({'stuff' => 'dude'})
      end
    end

    context 'when supplied an hash of data with key count greater than url variable count' do
      it 'returns hash containing data converted to param type' do
        extra_params = builder.extra_params({stuff: '2020-02-04', things: '2020-10-29'})
        expect(extra_params).to be_a(Hash)
        expect(extra_params['stuff']).to eq('2020-02-04')
      end
    end

  end

end
