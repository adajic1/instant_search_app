class ArticlesController < ApplicationController
  def index
    @articles=Article.order(id: :ASC)
    # render template: "articles/index" # not needed because ruby renders it by default
  end
  
  before_action :validate_params, only: [:create]
  def create
    if (!@params_valid) 
      send_data "ERROR: Invalid parameters"
    else 
      new_article = Article.create(article_params)
      send_data new_article.id
    end
  end
  
  def destroy_article
    Article.destroy(params[:id])
    send_data params[:id] 
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
