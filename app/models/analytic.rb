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
  
  # Constant
  RATIO_UPPER_LIMIT = 0.5 # Ratio limit of levenstein distance compared to longer string's length, for clustering
  
  # Get ordered hashes of arrays of similar search queries
  def self.get_ordered_arrays_of_similar_queries
    array_of_analytics = Analytic.all.to_a
    hashes_of_similar_queries = {}
    temp_hashes_of_similar_queries = {}
    for i in 0..array_of_analytics.length-1
      for j in 0..array_of_analytics.length-1
        next if i==j
        string1 = array_of_analytics[i].search_query
        string2 = array_of_analytics[j].search_query
        longer_length = [string1.length, string2.length].max.to_f
        levenstein_distance = string1.levenstein(string2).to_f
        ratio = levenstein_distance / longer_length
        puts ratio.to_s
      end
    end
    
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