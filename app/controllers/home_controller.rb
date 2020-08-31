class HomeController < ApplicationController
  before_action :set_endpoint, only: [:endpoint]

  def list_endpoints
    @endpoints = Endpoint.all
  end

  def endpoint
  end

  private

  def set_endpoint
    @endpoint = Endpoint.where(name: params[:request_name])
                        .where(client_tag: params[:client_tag]).first
  end
end
