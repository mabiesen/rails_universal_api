# frozen_string_literal: true

class EndpointClientTagValidator < ActiveModel::Validator
  attr_accessor :record, :brand

  def validate(record)
    @record = record
    @brand = record.client_tag
    client_tag_is_an_accepted_client_tag
  end

  def client_tag_is_an_accepted_client_tag
    client = @record.client
    @record.errors.add(:client_tag, 'has not yet implemented a client') if client.nil?
  end
end
