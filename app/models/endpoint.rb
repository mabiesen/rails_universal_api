# frozen_string_literal: true

class Endpoint < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :url_path, presence: true, uniqueness: true
  validates :params, presence: true
  validates :client_tag, presence: true
  validates :request_method, presence: true
  validates_with EndpointRequestMethodValidator
  validates_with EndpointNameValidator
  validates_with EndpointParamsValidator
  validates_with EndpointClientTagValidator
  validates_with EndpointUrlPathValidator
  validates_with EndpointBodyTemplateValidator

  has_many :batches

  CLIENT_MAP = { 'github' => GITHUB_CLIENT }.freeze

  def url_variables
    url_path.split('/').select { |x| x.include?(':') }.map do |var|
      var.delete(':')
    end
  end

  def client
    CLIENT_MAP[client_tag]
  end
end
