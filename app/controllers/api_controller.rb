# frozen_string_literal: true

require 'benchmark'

class ApiController < ApplicationController
  include ApiHelper
  before_action :set_arguments, only: [:call]
  before_action :set_endpoint, only: [:call]
  before_action :set_endpoints, only: [:list_endpoints]

  # returns list of endpoints
  def list_endpoints
    render json: @endpoints, status: 200
  end

  # makes an api request
  def call
    if @endpoint.nil?
      error_string = "no endpoint was found: #{@client_tag} with request #{@request_name}"
      render json: { error: error_string }, status: 404
    else
      begin
        response = nil
        benchmark = Benchmark.measure { response = make_request }
        render json: { benchmark: benchmark, status: response.status, body: response.body }, status: 200
      rescue StandardError => e
        render json: { error: e.to_s }, status: 500
      end
    end
  end

end
