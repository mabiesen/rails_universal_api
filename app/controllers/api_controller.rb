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
    if @endpoint.nil?
      error_string = "no endpoint was found: #{params[:client_tag]} with request #{params[:request_name]}"
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

  # validates all params relative to endpoint expectations
  def validate_params
    if @endpoint.nil?
      error_string = "no endpoint was found: #{params[:client_tag]} with request #{params[:request_name]}"
      render json: { error: error_string }, status: 404
    else
      begin
        erb = EndpointRequestBuilder.new(@endpoint)
        erb.validate(@arguments)
        render json: { success: 'Params look great!', arguments: @arguments, request_name: params[:request_name] }, status: 200
      rescue StandardError => e
        render json: { error: e.to_s }, status: 500
      end
    end
  end

  # validates one param in isolation
  def validate_param
    if @endpoint.nil?
      error_string = "no endpoint was found: #{params[:client_tag]} with request #{params[:request_name]}"
      render json: { error: error_string }, status: 404
    else
      begin
        erb = EndpointRequestBuilder.new(@endpoint)
        erb.validate_param(@arguments.keys.first.to_s, @arguments.values.first)
        render json: { success: 'Param looks great!' }, status: 200
      rescue StandardError => e
        render json: { error: e.to_s }, status: 500
      end
    end
  end

  private

  def make_request
    endpoint_client = EndpointClient.new(@endpoint)
    endpoint_client.request(@arguments)
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

  # array of arguments to be used in client call
  def set_arguments
    @arguments = params[:arguments]
  end
end
