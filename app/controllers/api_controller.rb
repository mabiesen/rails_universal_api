# frozen_string_literal: true

class ApiController < ApplicationController
  before_action :set_arguments, only: [:call]

  # returns list of endpoints
  def list_endpoints
    endpoints = Endpoint.all
    render json: endpoints, status: 200
  end

  # makes an api request
  def call
    @endpoint = Endpoint.where(name: params[:request_name])
                        .where(client_tag: params[:client_tag]).first
    raise 'That endpoint does not exist' if @endpoint.nil?

    endpoint_client = EndpointClient.new(@endpoint)
    response = endpoint_client.request(@arguments)
    respond_to do |format|
      format.json { render json: { status: response.status, body: response.body }, status: 200}
    end
  end

  private

  def set_arguments
    @arguments = params[:arguments]
  end
end
