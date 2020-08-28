# frozen_string_literal: true

class EndpointBrandValidator < ActiveModel::Validator
  attr_accessor :record, :brand

  def validate(record)
    @record = record
    @brand = record.brand
    brand_is_an_accepted_brand
  end

  def brand_is_an_accepted_brand
    client = @record.client
    @record.errors.add(:brand, 'has not yet implemented a client') if client.nil?
  end
end
