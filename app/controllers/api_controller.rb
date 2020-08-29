# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :set_arguments, only: [:call]
  before_action :set_endpoint, only: [:call]

  # returns list of endpoints
  def list_endpoints
    endpoints = Endpoint.all
    render json: endpoints, status: 200
  end

  # makes an api request
  def call
    raise 'That endpoint does not exist' if @endpoint.nil?

    response = make_request
    render json: { status: response.status, body: response.body }, status: 200
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

  # array of arguments to be used in client call
  def set_arguments
    @arguments = params[:arguments]
  end
end
