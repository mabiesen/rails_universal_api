# frozen_string_literal: true

# Houses logic to interface endpoints with job data
class EndpointRequestBuilder
  attr_reader :params, :url_variables, :url_path, :body_template

  def initialize(endpoint)
    @params = endpoint.params.deep_dup.stringify_keys
    @url_variables = endpoint.url_variables
    @url_path = endpoint.url_path.deep_dup
    @body_template = endpoint.body_template.deep_dup
  end

  def validate(arguments)
    validate_hash_inputs(arguments)
  end

  def formatted_url_path(arguments)
    formatted_url_path_for_hash(arguments)
  end

  def extra_params(arguments)
    extra_params_for_hash(arguments)
  end

  def validate_param(param_name, data)
    raise error_unidentified_param(param_name) unless @params.key?(param_name)

    optional = @params[param_name]['optional']
    data_type = @params[param_name]['type']

    raise error_required_param_blank(param_name) if !optional && data.blank?

    return if data.blank?

    raise error_bad_data_type(param_name, data_type, data) unless valid_data_for_type?(data, data_type)
  end

  private

  # validation occurs at the parameter collection and individual parameter level
  def validate_hash_inputs(data_hash)
    data_hash = data_hash.stringify_keys
    all_keys_in_params = data_hash.keys.all? do |k|
      @params.key?(k)
    end
    raise error_unidentified_params(data_hash.keys) unless all_keys_in_params

    @params.each do |key, _|
      validate_param(key, data_hash[key])
    end
  end

  # interpolate url parameters with real data
  def formatted_url_path_for_hash(data_hash)
    data_hash = data_hash.stringify_keys
    path = @url_path.deep_dup
    @url_variables.each do |key|
      path.gsub!(":#{key}", data_hash[key])
    end
    path
  end

  # identify parameters that are beyond the scope of url interpolation
  # convert 2d to 3d data if necessary
  # the hash that is returned should never values that were initially nil
  # the hash that is returned should never nil values in general
  def extra_params_for_hash(data_hash)
    data_hash = data_hash.stringify_keys
    final_hash = {}
    extra_keys = @params.keys - @url_variables
    extra_keys.each do |key|
      next if data_hash[key].blank?

      data_type = @params[key]['type']
      final_hash[key] = format_data_for_json(data_hash[key], data_type)
    end
    return final_hash if @body_template.nil?

    populate_body_template(final_hash)
  end

  def valid_data_for_type?(data, data_type)
    StringHelper.string_can_be_coerced_to_class?(data, data_type)
  end

  def format_data_for_json(value, type)
    return value unless %w[Integer Boolean Float].include?(type)

    StringHelper.coerce_string_to_class(value, type)
  end

  def populate_body_template(data_hash)
    hsh = HashHelper.replace_nested_hash_values_using_hash(@body_template.deep_dup, data_hash)
    HashHelper.remove_blanks_from_nested_hash(hsh)
  end

  def error_unidentified_params(data_keys)
    "input contains unidentified params.\n"\
    "Params received:\n#{data_keys}\n\n"\
    "Params allowed:\n#{@params.keys}"
  end

  def error_unidentified_param(param_name)
    "Supplied param_name '#{param_name}' "\
    'does not exist for endpoint'
  end

  def error_bad_data_type(param_name, param_type, data)
    "Data in column '#{param_name}' is not a valid '#{param_type}'.\n"\
    "Data supplied was :#{data}"
  end

  def error_required_param_blank(param_name)
    'No data supplied for column '\
    "'#{param_name}', column is not optional."
  end
end
