class ArticlesController < ApplicationController
  def index
    # render template: "articles/index" # not needed because ruby renders it by default
  end
  
  before_action :validate_params, only: [:create]
  def create
    if (!@params_valid) 
      send_data "ERROR: Invalid parameters"
    else 
      Article.create(article_params)
      send_data "OK"
    end
  end
  
  private
  
  def validate_params   
    @params_valid = true
    @params_valid = false if !params[:article].present? ||
                             !(params[:article][:description].present? rescue nil) ||
                             !(params[:article][:content].present? rescue nil)
  end
  
  def article_params
    params.require(:article).permit(:description, :content)
  end
  
end
