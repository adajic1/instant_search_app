class UserAction < ApplicationRecord
  belongs_to :session
  
  # Constant strings defining actions
  TYPE_SEARCH = "searched for"
  TYPE_CLICK = "clicked article"
  TYPE_READ = "read article"
  TYPE_CLOSE_TAB = "closed tab"
  TYPE_SUPPORT = "contacted support" 
  
  # Register last user action of session, TYPE_SEARCH
  def self.register_type_search(session, old_query_string, new_query_string) 
    return nil if new_query_string.blank?
    
    query_type = SearchQuery.get_type_of_search_query(session, old_query_string, new_query_string)
    if query_type == SearchQuery::QUERY_TYPE_NEW
      session.user_actions.create(action_type: UserAction::TYPE_SEARCH, description: new_query_string)
    elsif query_type == SearchQuery::QUERY_TYPE_UPDATE
      session.user_actions.last.update(action_type: UserAction::TYPE_SEARCH, description: new_query_string)
    end 
       
  end  
  
end
