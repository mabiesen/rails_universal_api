# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StringHelper do

  describe '#string_is_valid_string?' do
    context 'when supplied string with empty quotes' do
      it 'returns false' do
        expect(StringHelper.string_is_valid_string?('')).to be(false)
      end
    end
    context 'when supplied string with content' do
      it 'returns true' do
        expect(StringHelper.string_is_valid_string?('test')).to be(true)
      end
    end
  end

  describe '#string_is_valid_boolean?' do
    context "when supplied 'true' or 'false'" do
      it 'returns true' do
        expect(StringHelper.string_is_valid_boolean?('true')).to be(true)
      end
    end
    context "when supplied a value that is not 'true' or 'false'" do
      it 'returns false' do
        expect(StringHelper.string_is_valid_boolean?('test')).to be(false)
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
        expect(StringHelper.string_is_valid_date?('grkjl')).to be(false)
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
        expect(StringHelper.string_is_valid_float?('test')).to be(false)
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
        expect(StringHelper.string_is_valid_integer?('test')).to be(false)
      end
    end
  end
end
