class SearchQuery < ApplicationRecord
  belongs_to :session
  
  # Constants
  QUERY_TYPE_NEW = 1
  QUERY_TYPE_UPDATE = 2
  QUERY_TYPE_TEMPORARY = 3 # For this type of query we don't update analytics and user actions
  
  # Returns one of the QUERY_TYPE constants given above
  def self.get_type_of_search_query(session, old_query_string, new_query_string)
    
    levenstein_object = LevensteinService.call(new_query_string, old_query_string)
    if levenstein_object.number_of_substitutions > 0 
      return QUERY_TYPE_NEW
    elsif levenstein_object.number_of_insertions > 0 
      new_query = (!session.last_user_action_is_search? || session.user_actions.last.description != old_query_string)
      return QUERY_TYPE_NEW if new_query
      return QUERY_TYPE_UPDATE
    end     
    return QUERY_TYPE_TEMPORARY
    
  end

end
