# frozen_string_literal:true

require 'awesome_print'

class HomeController < ApplicationController
  before_action :set_endpoint, only: %i[endpoint_page]

  def index
    @endpoints = Endpoint.all
  end

  def endpoint_page
    render_home_request do
      render('endpoint_page')
    end
  end

  private

  def set_endpoint
    @endpoint = if params[:endpoint_id].present?
                  Endpoint.find(params[:endpoint_id])
                else
                  Endpoint.where(name: params[:request_name])
                          .where(client_tag: params[:client_tag]).first
                end
  end

  # wraps requests that contain endpoint instantiation to insure 404 not found
  def render_home_request
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
end
