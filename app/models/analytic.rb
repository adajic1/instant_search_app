class Analytic < ApplicationRecord
   
  # Update analytics of new_query_string and old_query_string, and last user action of session
  def self.compare_and_update(new_query_string, old_query_string, session) 
    return nil if new_query_string.blank?
    levenstein_object = LevensteinService.call(new_query_string, old_query_string)
    if levenstein_object.number_of_substitutions > 0 # It's a new search query 
      handle_counter_and_user_action_for_new_query(session, new_query_string)
    elsif levenstein_object.number_of_insertions > 0 # Possibly update of the previous search query  
      handle_counter_and_user_action_for_possibly_new_query(session, old_query_string, new_query_string)
    end       
  end  
  
  private
  
  # Handles counter and user_action for new search query
  def self.handle_counter_and_user_action_for_new_query(session, new_query_string) 
    counter_update_for(new_query_string, 1)
    session.user_actions.create(action_type: UserAction::TYPE_SEARCH, description: new_query_string)
  end
  
  # Checks with some logic if this should be treated as a new search query, or update of previous,
  # and handles counter and user_action accordingly
  def self.handle_counter_and_user_action_for_possibly_new_query(session, old_query_string, new_query_string)
    if !session.last_user_action_is_search? || session.user_actions.last.description != old_query_string
      # It's a new query
      session.user_actions.create(action_type: UserAction::TYPE_SEARCH, description: new_query_string)
    else # It's an update of the previous search query      
      counter_update_for(old_query_string, -1) 
      session.user_actions.last.update(action_type: UserAction::TYPE_SEARCH, description: new_query_string)
    end 
    counter_update_for(new_query_string, 1) 
  end
  
  # Increase or decrease counter for the given 'string' by 'number' value.
  # If counter becomes <=0, destroys record. If string is new, creates new record.
  def self.counter_update_for(string, number) 
    return 0 if string.blank?
    analytic_row = find_by_search_query(string)            
    if !analytic_row.nil? # string already exists in the database 
      analytic_row.destroy if analytic_row.counter + number <= 0
      analytic_row.update_attribute(:counter, analytic_row.counter + number) if analytic_row.counter + number > 0
    elsif number > 0 # string is new, so the record should be created now            
      create(counter: number, search_query: string)
    end    
  end  
  
end