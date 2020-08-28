 frozen_string_literal: true

class Endpoint < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :url_path, presence: true, uniqueness: true
  validates :params, presence: true
  validates :brand, presence: true
  validates :request_method, presence: true
  validates_with EndpointBrandValidator
  validates_with EndpointRequestMethodValidator
  validates_with EndpointNameValidator
  validates_with EndpointParamsValidator
  validates_with EndpointUrlPathValidator
  validates_with EndpointBodyTemplateValidator

  has_many :batches

  def url_variables
    url_path.split('/').select { |x| x.include?(':') }.map do |var|
      var.delete(':')
    end
  end

  def client
    case brand
    when 'some_brand'
      nil
    end
  end
end
