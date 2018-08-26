class Analytic < ApplicationRecord
   
  # Update analytics of new_query_string and old_query_string
  # * *Args*    :
  #   - +new_query_string+ -> new string submitted as search query
  #   - +old_query_string+ -> previous string submitted by the same user
  def self.update_for_last_two_queries(new_query_string, old_query_string) 
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
  # * *Args*    :
  #   - +string+ -> the string for which we update the counter
  #   - +number+ -> integer value by which we update the counter (can be negative)
  def self.count(string, number) 
    return 0 if string.blank? # do nothing for whitespaces or blank strings
    analytic_row = find_by_phrase(string)            
    if !analytic_row.nil? # string already exists in the database    
      update_or_destroy_existing_counter(analytic_row, number)    
    elsif number > 0 # string is new, so the record should be created now            
      create_new_counter(string, number)
    end    
  end  
  
  # Updates counter for given record. If counter becomes <=0, destroys record
  # * *Args*    :
  #   - +analytic_row+ -> data record from database
  #   - +number+ -> integer value by which we update the counter (can be negative)
  def self.update_or_destroy_existing_counter(analytic_row, number)
    analytic_row.update_attribute(:counter, analytic_row.counter+number)
    analytic_row.destroy if analytic_row.counter <= 0
  end
  
  # Creates new counter for given string.
  # * *Args*    :
  #   - +string+ -> phrase for new record
  #   - +number+ -> counter for new record. It should be > 0
  def self.create_new_counter(string, number)
    Analytic.create(counter: number, phrase: string)
  end
  
end