# frozen_string_literal:true

require "awesome_print"

class HomeController < ApplicationController
  def index
    @endpoints = Endpoint.all
  end
end
