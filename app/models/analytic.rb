class Analytic < ApplicationRecord
   
  # Update analytics of new_query_string and old_query_string
  def self.compare_and_update(new_query_string, old_query_string) 
    return nil if new_query_string.blank?
    levenstein_object = LevensteinService.call(new_query_string, old_query_string)
    if levenstein_object.number_of_substitutions > 0 # It's a new search query                
      Analytic.counter_update_for(new_query_string, 1)
    elsif levenstein_object.number_of_insertions > 0 # It's an update of the previous search query        
      Analytic.counter_update_for(old_query_string, -1)
      Analytic.counter_update_for(new_query_string, 1)
    end       
  end  
  
  def self.get_ordered_arrays_of_similar_queries
    array_of_analytics = Analytic.all.to_a
    puts array_of_analytic_records.inspect
  end
  
  private
  
  # Increase or decrease counter for the given 'string' by 'number' value.
  # If counter becomes <=0, destroys record. If string is new, creates new record.
  def self.counter_update_for(string, number) 
    return 0 if string.blank?
    analytic_row = find_by_search_query(string)            
    if !analytic_row.nil? # string already exists in the database    
      update_or_destroy_existing_counter(analytic_row, number)    
    elsif number > 0 # string is new, so the record should be created now            
      create(counter: number, search_query: string)
    end    
  end  
  
  # Updates counter for given record. If counter becomes <=0, destroys record
  def self.update_or_destroy_existing_counter(analytic_row, number)
    if analytic_row.counter + number <= 0
      analytic_row.destroy
    else
      analytic_row.update_attribute(:counter, analytic_row.counter + number)
    end
  end
  
end