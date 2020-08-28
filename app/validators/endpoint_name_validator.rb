# frozen_string_literal: true

class EndpointNameValidator < ActiveModel::Validator
  attr_accessor :record, :name

  def validate(record)
    @record = record
    @name = record.name
    name_does_not_have_spaces
  end

  def name_does_not_have_spaces
    @record.errors.add(:name, 'must not have spaces') unless @name.match(/\s/).nil?
  end
end
