# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from StandardError, with: :render_standard_error

  def render_standard_error(exception)
    redirect_to :controller => 'errors', :action => 'exception' 
  end
end
