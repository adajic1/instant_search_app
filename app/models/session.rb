class Session < ApplicationRecord
  has_many :search_queries, dependent: :destroy
  has_many :user_actions, dependent: :destroy
  
  # CONSTANTS
  SESSION_MINUTES = 5 # In minutes
  
  # Get Session instance with given :body -> ip_string. If it doesn't exist, it will be created.
  # * *Returns* :
  #   - Session object
  def self.get_or_create(ip_string) 
    back_in_time = DateTime.now - SESSION_MINUTES * 1.0 / (24 * 60)
    sessions = Session.where("body = ? AND created_at >= ?", ip_string, back_in_time)
    session = get_first_unclosed_session(sessions)
    session.nil? ? Session.create(body: ip_string, lastpartial: '') : session
  end  
  
  def last_user_action_is_search?
    return false if user_actions.last==nil || user_actions.last.action_type != UserAction::TYPE_SEARCH
    return true    
  end
  
  def last_user_action_is_close_tab?
    return false if user_actions.last==nil || user_actions.last.action_type != UserAction::TYPE_CLOSE_TAB
    return true    
  end 
  
  def self.get_first_unclosed_session(sessions)
    for i in 0..sessions.length-1
      return sessions[i] if !sessions[i].last_user_action_is_close_tab?
    end
    return nil
  end 
  
end
