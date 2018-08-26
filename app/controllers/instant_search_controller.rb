class InstantSearchController < ApplicationController
  
  def index
    # render template: "instant_search/index" # not needed because ruby renders it by default
  end
  
  def create
    query_string = params[:body] 
    IncomingSearchQueryService.call(query_string, request.remote_ip)       
    send_data query_string
  end
  
end
