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
    raise "Supplied param_name #{param_name} does not exist for endpoint" unless @params.key?(param_name)

    optional = @params[param_name]['optional']
    data_type = @params[param_name]['type']

    raise "No data supplied for column #{param_name}, column is not optional.#{data}" if !optional && data.blank?

    return if data.nil?

    raise "Data in column #{param_name} is not a valid #{data_type}" unless valid_data_for_type?(data, data_type)
  end

  private

  # validate inputs
  # validation occurs at the parameter collection and individual parameter level
  def validate_hash_inputs(data_hash)
    data_hash = data_hash.stringify_keys
    unidentified_key_error = "input contains unidentified params.\n"\
                             "Params received:\n#{data_hash.keys}\n\n"\
                             "Params expected/allowed:\n#{@params.keys}"
    raise unidentified_key_error unless data_hash.keys.all? { |k| @params.key?(k) }

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
  def extra_params_for_hash(data_hash)
    data_hash = data_hash.stringify_keys
    final_hash = {}
    extra_keys = @params.keys - @url_variables
    extra_keys.each do |key|
      data_type = @params[key]['type']
      final_hash[key] = format_data_for_json(data_hash[key], data_type)
    end
    final_hash = HashHelper.remove_blanks_from_hash(final_hash)
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
end
