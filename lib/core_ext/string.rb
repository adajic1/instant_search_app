class String

  # Calculate Levenstein distance between strings with given weighted costs
  # * *Returns* :
  #   - Levenstein distance
  def levenstein(other_string, insertion_cost=1, deletion_cost=1, substitution_cost=1)
    return nil if (self.nil? || other_string.nil?)
    
    target_length = self.length
    source_length = other_string.length   
    dm = Array.new(source_length+1) { Array.new(target_length+1) {0} } 
    # distance matrix, dimension (source_length+1)x(target_length+1)
    
    # initialize first row   
    for j in 1..target_length
      dm[0][j] = j * insertion_cost
    end
    
    # initialize first column
    for i in 1..source_length
      dm[i][0] = i * deletion_cost
    end 
    
    # populate matrix
    for i in 1..source_length
      for j in 1..target_length
        # critical comparison
        x1 = dm[i-1][j-1] + (self[j-1] == other_string[i-1] ? 0 : substitution_cost)
        x2 = dm[i][j-1] + insertion_cost
        x3 = dm[i-1][j] + deletion_cost
        dm[i][j] = [x1, x2, x3].min
      end
    end

    # the last value in matrix is the Levenstein distance between the strings
    dm[source_length][target_length]
  end
  
end
