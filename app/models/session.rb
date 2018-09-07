class Session < ApplicationRecord
  has_many :search_queries, dependent: :destroy
  has_many :user_actions, dependent: :destroy
  
  # CONSTANTS
  SESSION_MINUTES = 5 # In minutes
  
  # Get active Session instance with given :body -> ip_string. If it doesn't exist, it will be created.
  # * *Returns* :
  #   - Session object
  def self.get_or_create(ip_string) 
    back_in_time = DateTime.now - SESSION_MINUTES * 1.0 / (24 * 60)
    sessions = Session.where("body = ? AND created_at >= ?", ip_string, back_in_time)
    session = get_first_unclosed_session(sessions)
    session.nil? ? Session.create(body: ip_string, lastpartial: '') : session
  end  
  
  # Returns @sessions_info hash with sessions and additional data info
  def self.get_sessions_info            
    total_user_actions = 0
    sessions_with_single_search = 0
    sessions_with_multiple_search = 0
    sessions_contacted_support = 0
    sessions_closed_tab = 0
    
    sessions = order(id: :DESC)
    # Let's go through all sessions and their ations, and do all counting
    for i in 0..sessions.length-1
      user_actions = sessions[i].user_actions.order(id: :ASC)
      
      total_user_actions += user_actions.length # Counting
      sessions_closed_tab += 1 if user_actions.length > 0 && 
                                  user_actions.last.action_type == UserAction::TYPE_CLOSE_TAB # Counting
      
      num_of_search_queries_of_session = 0
      contacted_support = false
      
      # Let's got through all user actions of this session
      for j in 0..user_actions.length-1
        user_action = user_actions[j]
        num_of_search_queries_of_session += 1 if user_action.action_type == UserAction::TYPE_SEARCH
        contacted_support = true if user_action.action_type == UserAction::TYPE_SUPPORT
      end
          
      sessions_with_single_search += 1 if num_of_search_queries_of_session == 1 # Counting
      sessions_with_multiple_search += 1 if num_of_search_queries_of_session > 1 # Counting
      sessions_contacted_support += 1 if contacted_support # Counting      
    end
    
    @sessions_info = {}
    @sessions_info["sessions"] = sessions
    @sessions_info["total_sessions"] = sessions.length 
    @sessions_info["total_user_actions"] = total_user_actions
    @sessions_info["sessions_with_single_search"] = sessions_with_single_search
    @sessions_info["sessions_with_multiple_search"] = sessions_with_multiple_search
    @sessions_info["sessions_contacted_support"] = sessions_contacted_support
    @sessions_info["sessions_closed_tab"] = sessions_closed_tab
    @sessions_info   
  end
  
  def last_user_action_is_search?
    return false if user_actions.last==nil || user_actions.last.action_type != UserAction::TYPE_SEARCH
    return true    
  end
  
  def last_user_action_is_close_tab?
    return false if user_actions.last==nil || user_actions.last.action_type != UserAction::TYPE_CLOSE_TAB
    return true    
  end 
  
  private
  
  def self.get_first_unclosed_session(sessions)
    for i in 0..sessions.length-1
      return sessions[i] if !sessions[i].last_user_action_is_close_tab?
    end
    return nil
  end 
  
end
