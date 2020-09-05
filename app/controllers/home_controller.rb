# frozen_string_literal:true

class HomeController < ApplicationController
  def index
    @endpoints = Endpoint.all
  end

  def endpoint
    @endpoint = Endpoint.find(params[:endpoint_id])
  end
end
