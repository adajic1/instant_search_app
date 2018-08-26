class InstantSearchController < ApplicationController
  
  def index
    render template: "instant_search/index"
  end
  
  def create
    query_string = params[:body] 
    IncomingSearchQueryService.call(query_string, request.remote_ip)       
    send_data query_string
  end
  
end
