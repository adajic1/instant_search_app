class InstantSearchController < ApplicationController
  
  # Show instant search webpage
  def index
    # render template: "instant_search/index" # not needed because ruby renders it by default
  end
  
  # New search query
  def create
    IncomingSearchQueryService.call(params[:body], request.remote_ip) 
      
    return_data = {}
    return_data["articles"] = Article.get_relevant_articles(params[:body]) 
    return_data["query"] = params[:body]

    send_data return_data.to_json
  end
  
end
