# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StringHelper do

  let(:test_data_hash) { { 'String' => 'a_string',
                           'Date' => '2020-12-27',
                           'Boolean' => 'true',
                           'Integer' => '209',
                           'Float' => '30.33'} }

  describe '#string_can_be_coerced_to_class' do
    context 'when called with uppercase type' do
      it 'should process the request successfull' do
        ans = StringHelper.string_can_be_coerced_to_class?('true', 'DATE')
        expect(ans).to be_a(FalseClass)
      end
    end

    context 'when called with mixed case type' do
      it 'should process the request successfully' do
        ans = StringHelper.string_can_be_coerced_to_class?('2020-12-23', 'DaTe')
        expect(ans).to be_a(TrueClass)
      end
    end
  end

  describe '#string_is_valid_boolean?' do
    context "when supplied 'true' or 'false' strings, with any cpitalization" do
      it 'returns true' do
        expect(StringHelper.string_is_valid_boolean?('true')).to be(true)
        expect(StringHelper.string_is_valid_boolean?('false')).to be(true)
        expect(StringHelper.string_is_valid_boolean?('FaLse')).to be(true)
      end
    end
    context "when supplied a value that is not 'true' or 'false'" do
      it 'returns false' do
        test_data_hash.each do |key, value|
          next if key == 'Boolean'

          expect(StringHelper.string_is_valid_boolean?(value)).to be(false)
        end
      end
    end
  end

  describe '#string_is_valid_date?' do
    context 'when supplied a parseable date' do
      it 'returns true' do
        expect(StringHelper.string_is_valid_date?('2020-07-09')).to be(true)
      end
    end
    context 'when supplied a non-parseable date' do
      it 'returns false' do
        test_data_hash.each do |key, value|
          next if key == 'Date'

          expect(StringHelper.string_is_valid_date?(value)).to be(false)
        end
      end
    end
  end

  describe '#string_is_valid_float?' do
    context 'when supplied a string that can be parsed into a float' do
      it 'returns true' do
        expect(StringHelper.string_is_valid_float?('124.14')).to be(true)
      end
    end
    context 'when supplied a string that cannot be parsed into a float' do
      it 'returns false' do
        test_data_hash.each do |key, value|
          next if key == 'Float' || key == 'Integer'

          expect(StringHelper.string_is_valid_float?(value)).to be(false)
        end
      end
    end
  end

  describe '#string_is_valid_integer?' do
    context' when supplied a string that can be parsed to an integer' do
      it 'returns true' do
        expect(StringHelper.string_is_valid_integer?('12000')).to be(true)
      end
    end
    context 'when supplied a string that cannot be parsed into an integer' do
      it 'returns false' do
        test_data_hash.each do |key, value|
          next if key == 'Integer' || key == 'Float'

          expect(StringHelper.string_is_valid_integer?(value)).to be(false)
        end
      end
    end
  end
end
