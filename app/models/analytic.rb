class Analytic < ApplicationRecord
   
  # Handle analytics of new and old query
  def self.handle_counters_based_on_query_type(session, old_query_string, new_query_string) 
    return nil if new_query_string.blank?
    
    query_type = SearchQuery.get_type_of_search_query(session, old_query_string, new_query_string)
    if query_type == SearchQuery::QUERY_TYPE_NEW
      increase_or_decrease_counter(new_query_string, 1)      
    elsif query_type == SearchQuery::QUERY_TYPE_UPDATE
      increase_or_decrease_counter(old_query_string, -1)
      increase_or_decrease_counter(new_query_string, 1) 
    end  
    
    # Do nothing for QUERY_TYPE_TEMPORARY,
    # for example user is deleting characters - so analytics won't be changed until he starts to type again 
  end  
  
  private
    
  # Increase or decrease counter for the given 'string' by 'number' value.
  # If counter becomes <=0, destroys record. If string is new, creates new record.
  def self.increase_or_decrease_counter(string, number) 
    return 0 if string.blank?
    
    analytic_row = find_by_search_query(string)            
    if !analytic_row.nil? 
      # string already exists in the database 
      analytic_row.destroy if analytic_row.counter + number <= 0
      analytic_row.update_attribute(:counter, analytic_row.counter + number) if analytic_row.counter + number > 0
    elsif number > 0 
      # string is new, so the record should be created now            
      create(counter: number, search_query: string)
    end
           
  end    
  
end