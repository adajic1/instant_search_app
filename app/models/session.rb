class Session < ApplicationRecord
  has_many :search_queries, dependent: :destroy
  
  # Get Session instance with given :body. If it doesn't exist, it will be created.
  # * *Args*    :
  #   - +ip_string+ -> IP address which we are looking for
  # * *Returns* :
  #   - Session object
  def self.get_or_create(ip_string) 
    session = find_by_body(ip_string)
    session.nil? ? Session.create(body: ip_string, lastpartial: '') : session
  end  
end
