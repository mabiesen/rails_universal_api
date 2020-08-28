# frozen_string_literal: true

require 'hashie'

module HashHelper
  module_function

  # api calls often require the use of nested hashes
  # for many use-cases, the consumer should not be provided
  # a nested form: the consumer should be provided a 2d interface
  # that can translate to a 3d data structure
  def replace_nested_hash_values_using_hash(nested_hsh, regular_hsh)
    nested_hsh.extend(Hashie::Extensions::DeepLocate)
    regular_hsh.each do |dh_key, dh_value|
      nested_hsh.deep_locate ->(key, value, object) do
        next if key.nil?

        object[key] = dh_value if dh_key.to_sym == key.to_sym && value.nil?
        false
      end
    end
    nested_hsh
  end

  # remove nils and empty hashes from a nested hash
  def remove_blanks_from_nested_hash(nested_hsh)
    nested_hsh.extend(Hashie::Extensions::DeepLocate)
    run_had_blanks = true
    while run_had_blanks
      run_had_blanks = false
      nested_hsh.deep_locate ->(key, value, object) do
        if value.blank?
          object.delete key
          run_had_blanks = true
        elsif value.is_a?(Array) || value.is_a?(Hash)
          if value.all?(&:blank?)
            object.delete key
            run_had_blanks == true
          end
        end
        false
      end
    end
    nested_hsh
  end

  def nested_hash_contains_duplicate_keys?(nested_hsh)
    nested_hsh.extend(Hashie::Extensions::DeepLocate)
    nested_hsh.extend(Hashie::Extensions::DeepFind)
    dupes = []
    nested_hsh.deep_locate ->(key, _value, _object) do
      next if key.nil?

      dupes.push(key) if nested_hsh.deep_select(key).count > 1
      false
    end
    return true if dupes.count.positive?

    false
  end

  def nested_hash_has_key?(nested_hsh, key)
    nested_hsh.extend(Hashie::Extensions::DeepFind)
    !nested_hsh.deep_select(key).blank?
  end
end
