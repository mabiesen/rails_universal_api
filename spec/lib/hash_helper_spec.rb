# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HashHelper do
  let(:data_hash) { {var: 'thing', other_var: 'place', something: 'person'} }

  let(:nested_hash) { 
    { var: nil,
      other_var: nil,
      wrapper: {
        something: nil
      }
    }
  }

  let(:nested_hash_with_duped_keys) {
    { var: nil,
      other_var: nil,
      wrapper: {
        var: nil
      }
    }
  }

  let(:nested_hash_with_arrayed_hash) {
    { var: nil,
      other_var: nil,
      wrapper: [
        {something: nil,
         something_else: nil}
      ]
    }
  }

  let(:nested_with_array_duped_keys) {
    { var: nil,
      something: nil,
      wrapper: [
        {something: nil,
         something_else: nil}
      ]
    }
  }

  describe '#replace_nested_hash_values_using_hash' do
    context 'when supplied a nested hash and a data hash' do
      it 'returns nested hash with interpolated data' do
        interpoled_hash = HashHelper.replace_nested_hash_values_using_hash(nested_hash, data_hash)
        expect(interpoled_hash[:wrapper][:something]).to eq('person')
        expect(interpoled_hash[:var]).to eq('thing')
        expect(interpoled_hash[:other_var]).to eq('place')

        interpoled_hash = HashHelper.replace_nested_hash_values_using_hash(nested_hash_with_arrayed_hash, data_hash)
        expect(interpoled_hash[:wrapper][0][:something]).to eq('person')
      end
    end
  end

  describe '#remove_blanks_from_nested_hash' do
    context 'when supplied a nested hash containing blanks' do
      it 'returns nested hash containing no nils or empty values' do
        nested_hash[:var] = 'thing'
        expect(HashHelper.remove_blanks_from_nested_hash(nested_hash)).to eq(var: 'thing')
        
        nested_hash_with_arrayed_hash[:var] = 'thing'
        expect(HashHelper.remove_blanks_from_nested_hash(nested_hash_with_arrayed_hash)).to eq(var: 'thing')
      end
    end
  end

  describe '#nested_hash_contains_duplicate_keys?' do
    context 'when supplied a nested hash containing duplicated keys' do
      it 'returns true' do
        expect(HashHelper.nested_hash_contains_duplicate_keys?(nested_hash_with_duped_keys)).to be(true)
        expect(HashHelper.nested_hash_contains_duplicate_keys?(nested_with_array_duped_keys)).to be(true)
      end
    end
    context 'when supplied a nested hash NOT containing duplicated keys' do
      it 'returns false' do
        expect(HashHelper.nested_hash_contains_duplicate_keys?(nested_hash)).to be(false)
        expect(HashHelper.nested_hash_contains_duplicate_keys?(nested_hash_with_arrayed_hash)).to be(false)
      end
    end
  end

  describe '#nested_hash_has_key?' do
    context 'when supplied nested hash containing key' do
      it 'returns true' do
        expect(HashHelper.nested_hash_has_key?(nested_hash, :var)).to be(true)
        expect(HashHelper.nested_hash_has_key?(nested_hash_with_arrayed_hash, :something_else)).to be(true)
      end
    end

    context 'when supplied a nested hash NOT containing key' do
      it 'returns false' do
        expect(HashHelper.nested_hash_has_key?(nested_hash, :george)).to be(false)
        expect(HashHelper.nested_hash_has_key?(nested_hash_with_arrayed_hash, :dude)).to be(false)
      end
    end
  end

end
