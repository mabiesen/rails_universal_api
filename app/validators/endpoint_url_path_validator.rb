# frozen_string_literal: true

class EndpointUrlPathValidator < ActiveModel::Validator
  attr_accessor :record, :url_path

  def validate(record)
    @record = record
    @url_path = record.url_path
    starts_with_slash
    does_not_end_in_slash
  end

  def starts_with_slash
    @record.errors.add(:url, 'must start with forward slash') unless @url_path[0] == '/'
  end

  def does_not_end_in_slash
    @record.errors.add(:url, 'must not end in slash') if @url_path[-1] == '/'
  end

end
