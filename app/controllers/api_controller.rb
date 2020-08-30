# frozen_string_literal: true

class ApiController < ApplicationController
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
      response = make_request
      render json: { status: response.status, body: response.body }, status: 200
    end
  end

  private

  # executes the api request
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
    @endpoints = Endpoint.where("client_tag like ?", "%#{params[:client_tag]}%")
                         .where("name like ?", "%#{params[:request_name]}%")
  end

  # array of arguments to be used in client call
  def set_arguments
    @arguments = params[:arguments]
  end
end
