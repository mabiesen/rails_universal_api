# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :set_endpoint, only: %i[request]
  before_action :set_arguments, only: %i[request]

  # returns list of endpoints
  def list_endpoints
    endpoints = Endpoint.all
    respond_to do |format|
      format.json { render json: endpoints}
    end
  end

  def request
    client = @endpoint.client
    endpoint_client = EndpointClient.new(endpoint)
    response = endpoint_client.request(@arguments) 
    respond_to do |format|
      format.json { render json:  'stuff'}
    end
  end

  private

  def set_endpoint
    @endpoint = Endpoint.where(name: params[:name],
                               client_tag: params[:client_tag]).first
  end

  def set_arguments
    @arguments = params[:arguments]
  end

end
