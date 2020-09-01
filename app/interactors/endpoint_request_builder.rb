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
    if arguments.is_a? Hash
      validate_hash_inputs(arguments)
    else
      validate_array_inputs(arguments)
    end
  end

  def formatted_url_path(arguments)
    if arguments.is_a? Hash
      formatted_url_path_for_hash(arguments)
    else
      formatted_url_path_for_array(arguments)
    end
  end

  def extra_params(arguments)
    if arguments.is_a? Hash
      extra_params_for_hash(arguments)
    else
      extra_params_for_array(arguments)
    end
  end

  def validate_param(param_name, data)
    optional = @params[param_name]['optional']
    data_type = @params[param_name]['type']
    raise "No data supplied for column #{param_name}, column is not optional.#{data}" if !optional && data.blank?

    return if data.nil?

    raise "Data in column #{param_name} is not a valid #{data_type}" unless valid_data_for_type?(data, data_type)
  end

  private

  def validate_hash_inputs(data_hash)
    data_hash = data_hash.stringify_keys
    raise 'input contains unidentified params' unless (data_hash.keys - @params.keys).empty?

    @params.each do |key, _|
      validate_param(key, data_hash[key])
    end
  end

  def validate_array_inputs(data_array)
    @params.keys.each_with_index do |param_name, i|
      validate_param(param_name, data_array[i])
    end
  end
  
  # replace variables in url path by position
  def formatted_url_path_for_array(data_array)
    data_to_replace_variables = data_array.first(@url_variables.count)
    path = @url_path.deep_dup
    @url_variables.each_with_index do |data, i|
      path.gsub!(":#{data}", data_to_replace_variables[i])
    end
    path
  end

  def formatted_url_path_for_hash(data_hash)
    data_hash = data_hash.stringify_keys
    path = @url_path.deep_dup
    @url_variables.each do |key|
      path.gsub!(":#{key}", data_hash[key])
    end
    path
  end

  def extra_params_for_hash(data_hash)
    data_hash = data_hash.stringify_keys
    final_hash = {}
    extra_keys = @params.keys - @url_variables
    extra_keys.each do |key|
      final_hash[key] = data_hash[key]
    end
    final_hash = populate_body_template(final_hash) unless @body_template.nil?
    final_hash
  end

  # if the supplied data had a greater count than endpoint url variables,
  # creates hash containing 'leftover' data paired with 'leftover' param names
  def extra_params_for_array(data_array)
    final_hash = {}
    data_hash = Hash[@params.keys.zip(data_array)]
    data_hash.delete_if { |k, _| @params.keys.first(@url_variables.count).include?(k) }
    data_hash.compact!
    data_hash.each do |k, v|
      type = @params[k]['type']
      # Numbers and boolean values are not passed as strings in json
      final_hash[k] = format_data_for_json(v, type)
    end
    final_hash = populate_body_template(final_hash) unless @body_template.nil?
    final_hash
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
