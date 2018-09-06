class AnalyticsController < ApplicationController
  def index
    @analytics = Analytic.order(counter: :DESC)
    # render template: "analytics/index" # not needed because ruby renders it by default
  end
  
  # Destroys all data from tables
  def destroy
    Session.destroy_all
    Analytic.destroy_all
    send_data "Cleared successfully..." 
  end
  
  # Destroys particular record
  def destroy_record    
    Analytic.destroy(params[:id])
    send_data params[:id] 
  end
  
end
