# frozen_string_literal: true

class EndpointParamsValidator < ActiveModel::Validator
  attr_accessor :record

  def validate(record)
    @record = record
    if @record.params.blank?
      @record.errors.add(:params, 'field cannot be blank')
    else
      validate_params_include_url_variables
      @record.params.each do |k, v|
        validate_param(k => v)
      end
    end
  end

  def validate_params_include_url_variables
    params = @record.params
    url_variables = @record.url_variables
    params_contain_all_url_variables = (params.keys.count - (params.keys - url_variables).count) == url_variables.count
    @record.errors.add(:params, 'must contain url variables') unless params_contain_all_url_variables
  end

  def validate_param(param_hash)
    if param_hash.values.first.is_a?(Hash)
      validate_param_type(param_hash)
      validate_param_optionality(param_hash)
    else
      @record.errors.add(:params,
                         'each param should map to a hash containing type and optionality')
    end
  end

  def validate_param_type(param_hash)
    if param_hash.values.first.key?('type')
      validate_param_type_value(param_hash)
    else
      @record.errors.add(:params,
                         'each param must have attribute indicating data type')
    end
  end

  def validate_param_optionality(param_hash)
    if param_hash.values.first.key?('optional')
      validate_param_optionality_value(param_hash)
    else
      @record.errors.add(:params,
                         'all params must have attribute indicating optionality')
    end
  end

  def validate_param_optionality_value(param_hash)
    arg_is_bool = [true, false].include?(param_hash.values.first['optional'])
    return if arg_is_bool

    @record.errors.add(:params,
                       'all params optional attributes should be true or false')
  end

  def validate_param_type_value(param_hash)
    valid_types = %w[Date String Float Integer Boolean]
    has_valid_type = valid_types.include?(param_hash.values.first['type'])
    error_string = "all params must use one of the following types:\n#{valid_types.join("\n")}"
    @record.errors.add(:params, error_string) unless has_valid_type
  end
end
