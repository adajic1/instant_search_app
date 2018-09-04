class Session < ApplicationRecord
  has_many :search_queries, dependent: :destroy
  
  # Get Session instance with given :body -> ip_string. If it doesn't exist, it will be created.
  # * *Returns* :
  #   - Session object
  def self.get_or_create(ip_string) 
    session = find_by_body(ip_string)
    session.nil? ? Session.create(body: ip_string, lastpartial: '') : session
  end  
end
