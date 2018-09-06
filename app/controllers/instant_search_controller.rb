class InstantSearchController < ApplicationController
  
  # Show instant search webpage
  def index
    # render template: "instant_search/index" # not needed because ruby renders it by default
  end
  
  # New search query
  def create
    query_string = params[:body] 
    IncomingSearchQueryService.call(query_string, request.remote_ip)   
    @articles = Article.get_relevant_articles(query_string) 
    return_data = {}
    return_data["articles"] = @articles
    return_data["query"] = query_string
    send_data return_data.to_json
  end
  
end
