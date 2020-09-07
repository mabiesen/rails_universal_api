# frozen_string_literal:true

require 'awesome_print'

class HomeController < ApplicationController
  before_action :set_endpoint, only:  %i[endpoint]

  def index
    @endpoints = Endpoint.all
  end

  def endpoint
    @endpoint
  end

  private

  def set_endpoint
    if !params[:endpoint_id].nil?
      @endpoint = Endpoint.find(params[:endpoint_id])
    else
      @endpoint = Endpoint.where(name: params[:request_name])
                          .where(client_tag: params[:client_tag]).first
    end
  end
end
