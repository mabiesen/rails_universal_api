# frozen_string_literal: true

class EndpointBodyTemplateValidator < ActiveModel::Validator
  attr_accessor :record, :params, :url_variables, :body_template

  def validate(record)
    @record = record
    @params = record.params
    @body_template = record.body_template
    @url_variables = record.url_variables
    return if @body_template.blank?

    body_template_contains_all_non_url_variable_param_keys
    body_template_does_not_contain_duplicate_keys
  end

  def body_template_contains_all_non_url_variable_param_keys
    non_url_param_keys = @params.keys - @url_variables
    non_url_param_keys.each do |key|
      hsh_has_key = HashHelper.nested_hash_has_key?(@body_template, key)
      @record.errors.add(:body_template, 'must contain all endpoint params') unless hsh_has_key
    end
  end

  def body_template_does_not_contain_duplicate_keys
    has_duplicate_keys = HashHelper.nested_hash_contains_duplicate_keys?(@body_template)
    @record.errors.add(:body_template, 'must not contain duplicate keys') if has_duplicate_keys
  end
end
