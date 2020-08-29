# frozen_string_literal: true

# Houses logic to interface endpoints with job data
class EndpointRequestBuilder
  attr_reader :params, :url_variables, :url_path, :body_template

  def initialize(endpoint)
    @params = endpoint.params.deep_dup
    @url_variables = endpoint.url_variables
    @url_path = endpoint.url_path.deep_dup
    @body_template = endpoint.body_template.deep_dup
  end

  def validate(data_array)
    @params.keys.each_with_index do |param_name, i|
      optional = @params[param_name]['optional']
      data_type = @params[param_name]['type']
      data = data_array[i]

      raise "No data supplied for column #{param_name}, column is not optional." if !optional && data.nil?

      next if data.nil?

      raise "Data in column #{param_name} is not a valid #{data_type}" unless valid_data_for_type?(data, data_type)
    end
  end

  # replace variables in url path by position
  def formatted_url_path(data_array)
    data_to_replace_variables = data_array.first(@url_variables.count)
    path = @url_path.deep_dup
    @url_variables.each_with_index do |data, i|
      path.gsub!(":#{data}", data_to_replace_variables[i])
    end
    path
  end

  # if the supplied data had a greater count than endpoint url variables,
  # creates hash containing 'leftover' data paired with 'leftover' param names
  def extra_params(data_array)
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

  private

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
