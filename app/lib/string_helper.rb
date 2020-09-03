# frozen_string_literal: true

module StringHelper
  module_function

  def string_can_be_coerced_to_class?(string, type)
    case type
    when 'String'
      string_is_valid_string?(string)
    when 'Boolean'
      string_is_valid_boolean?(string)
    when 'Date'
      string_is_valid_date?(string)
    when 'Float'
      string_is_valid_float?(string)
    when 'Integer'
      string_is_valid_integer?(string)
    end
  end

  def string_is_valid_string?(string)
    true
  end

  def string_is_valid_boolean?(string)
    %w[true false].include?(string.downcase)
  end

  def string_is_valid_date?(string)
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
    Float(string)
    true
  rescue StandardError
    false
  end

  def string_is_valid_integer?(string)
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
      string.downcase == 'true'
    when 'Date'
      Date.parse(string)
    when 'Float'
      Float(string)
    when 'Integer'
      string.to_i
    end
  end
end
