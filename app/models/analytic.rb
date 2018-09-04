class Analytic < ApplicationRecord
   
  # Update analytics of new_query_string and old_query_string
  def self.compare_and_update(new_query_string, old_query_string) 
    return nil if new_query_string.blank?
    levenstein_array = LevensteinService.call(new_query_string, old_query_string)
    number_of_insertions, number_of_deletions, number_of_substitutions = levenstein_array
    if number_of_substitutions > 0 # It's a new phrase                
      Analytic.count(new_query_string, 1)
    elsif number_of_insertions > 0 # It's an update of the previous phrase        
      Analytic.count(old_query_string, -1)
      Analytic.count(new_query_string, 1)
    end       
  end  
  
  private
  
  # Increase or decrease counter for the given 'string' by 'number' value.
  # If counter becomes <=0, destroys record. If string is new, creates new record.
  def self.count(string, number) 
    return 0 if string.blank? # do nothing for whitespaces or blank strings
    analytic_row = find_by_phrase(string)            
    if !analytic_row.nil? # string already exists in the database    
      update_or_destroy_existing_counter(analytic_row, number)    
    elsif number > 0 # string is new, so the record should be created now            
      create(counter: number, phrase: string)
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