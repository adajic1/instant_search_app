class AnalyticsController < ApplicationController
  def index
    @analytics=Analytic.order(counter: :DESC)
    # render template: "analytics/index" # not needed because ruby renders it by default
  end
  
  def destroy
    Session.destroy_all
    Analytic.destroy_all
    send_data "Cleared successfully..." 
  end
end
