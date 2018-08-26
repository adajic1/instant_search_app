class AnalyticsController < ApplicationController
  def index
    @analytics=Analytic.order(counter: :DESC)
    render template: "analytics/index"
  end
  
  def destroy
    Session.destroy_all
    Analytic.destroy_all
    send_data "Cleared successfully..." 
  end
end
