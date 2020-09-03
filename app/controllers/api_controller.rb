# frozen_string_literal: true

require 'benchmark'

class ApiController < ApplicationController
  before_action :set_arguments, only: %i[call validate_params validate_param]
  before_action :set_endpoint, only:  %i[call validate_params validate_param]
  before_action :set_endpoints, only: [:list_endpoints]

  # returns list of endpoints
  def list_endpoints
    render json: @endpoints, status: 200
  end

  # makes an api request
  def call
    render_endpoint_request do
      benchmark, response = make_benchmarked_request
      render json: { benchmark: benchmark, status: response.status, body: response.body }, status: 200
    end
  end

  # validates all params relative to endpoint expectations
  def validate_params
    render_endpoint_request do
      erb = EndpointRequestBuilder.new(@endpoint)
      erb.validate(@arguments)
      render json: { success: 'Params look great!' }, status: 200
    end
  end

  # validates one param in isolation
  def validate_param
    render_endpoint_request do
      erb = EndpointRequestBuilder.new(@endpoint)
      erb.validate_param(@arguments.keys.first.to_s, @arguments.values.first)
      render json: { success: 'Param looks like the right data type! good job!' }, status: 200
    end
  end

  private

  # wraps requests that contain endpoint instantiation to insure 404 not found
  def render_endpoint_request
    if @endpoint.nil?
      error_string = "no endpoint was found for client: #{params[:client_tag]} with request: #{params[:request_name]}"
      render json: { error: error_string }, status: 404
    else
      begin
        yield
      rescue StandardError => e
        render json: { error: e.to_s }, status: 500
      end
    end
  end

  def build_request
    erb = EndpointRequestBuilder.new(@endpoint)
    erb.validate(@arguments)
    url_path = erb.formatted_url_path(@arguments)
    extra_params = erb.extra_params(@arguments)
    [url_path, extra_params]
  end

  def make_benchmarked_request
    url_path, extra_params = build_request
    ec = EndpointClient.new(@endpoint)
    response = nil
    benchmark = Benchmark.measure { response = ec.request(url_path, extra_params) }
    [benchmark, response]
  end

  # endpoint is defined by its client and name
  def set_endpoint
    @endpoint = Endpoint.where(name: params[:request_name])
                        .where(client_tag: params[:client_tag]).first
  end

  # list of endpoints like params if params supplied
  # nil params yield all endpoints
  def set_endpoints
    @endpoints = Endpoint.where('client_tag like ?', "%#{params[:client_tag]}%")
                         .where('name like ?', "%#{params[:request_name]}%")
  end

  # hash of arguments to be used in client call
  # we are rejecting parameters which are either
  # 1) part of url path, 2) rails(httpie?) magicky idk what 'api' var
  def set_arguments
    exclusion_list = %w[client_tag api request_name]
    all_parameters = request.request_parameters
    @arguments = all_parameters.reject{|param_name, _| exclusion_list.include?(param_name) }
  end
end
