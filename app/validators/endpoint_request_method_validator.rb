# frozen_string_literal: true

class EndpointRequestMethodValidator < ActiveModel::Validator
  attr_accessor :record, :request_method

  def validate(record)
    @record = record
    @request_method = @record.request_method
    request_method_is_accepted_method
  end

  def request_method_is_accepted_method
    is_valid_method = %w[put post get].include? @request_method
    @record.errors.add(:request_method, 'request method is not put or post method') unless is_valid_method
  end
end
