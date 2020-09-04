# frozen_string_literal: true

module StringHelper
  module_function

  def string_can_be_coerced_to_class?(string, type)
    case type
    when 'String'
      ans = string_is_valid_string?(string)
    when 'Boolean'
      ans = string_is_valid_boolean?(string)
    when 'Date'
      ans = string_is_valid_date?(string)
    when 'Float'
      ans = string_is_valid_float?(string)
    when 'Integer'
      ans = string_is_valid_integer?(string)
    end
    puts ans
    return ans
  end

  def string_is_valid_string?(_string)
    puts "evaluating #{_string} for string"
    true
  end

  def string_is_valid_boolean?(string)
    puts "evaluating #{string} for bool"
    %w[true false].include?(string.downcase)
  end

  def string_is_valid_date?(string)
    puts "evaluating #{string} for date"
    format_ok = string.match(/\d{4}-\d{2}-\d{2}/)
    begin
      parseable = Date.strptime(string, '%Y-%m-%d')
    rescue StandardError
      parseable = false
    end

    return true if format_ok && parseable

    false
  end

  def string_is_valid_float?(string)
    puts "evaluating #{string} for float"
    Float(string)
    true
  rescue StandardError
    false
  end

  def string_is_valid_integer?(string)
    puts "evaluating #{string} for integer"
    Integer(string)
    true
  rescue StandardError
    false
  end

  def coerce_string_to_class(string, type)
    case type
    when 'String'
      string
    when 'Boolean'
      string.casecmp?('true').zero?
    when 'Date'
      Date.parse(string)
    when 'Float'
      Float(string)
    when 'Integer'
      string.to_i
    end
  end
end
