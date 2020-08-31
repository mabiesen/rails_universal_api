# frozen_string_literal:true

module ApiHelper

  # endpoint is defined by its client and name
  def set_endpoint
    @endpoint = Endpoint.where(name: params[:request_name])
                        .where(client_tag: params[:client_tag]).first
  end

  # list of endpoints like params if params supplied
  # nil params yield all endpoints
  def set_endpoints
    @endpoints = Endpoint.where('client_tag like ?', "%#{params[:client_tag]}%")
                         .where('name like ?', "%#{params[:request_name]}%")
  end

  # array of arguments to be used in client call
  def set_arguments
    @arguments = params[:arguments]
  end

end
