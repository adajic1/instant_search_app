class String

  # Calculate Levenstein distance between strings with given weighted costs
  # * *Args*    :
  #   - +other+ -> the string against which we calculate Levenstein distance
  #   - +ins+ -> cost value of char insertion
  #   - +del+ -> cost value of char deletion
  #   - +sub+ -> cost value of char substitution
  # * *Returns* :
  #   - Levenstein distance
  def levenshtein(other, ins=1, del=1, sub=1)
    # ins, del, sub are weighted costs
    return nil if (self.nil? || other.nil?)
    
    t_len = self.length # target length
    s_len = other.length # source length    
    dm = Array.new(s_len+1) { Array.new(t_len+1) {0} } # distance matrix, dimension (s_len+1)x(t_len+1)
    
    # initialize first row   
    for j in 1..t_len
      dm[0][j] = j * ins
    end
    
    # initialize first column
    for i in 1..s_len
      dm[i][0] = i * del
    end 
    
    # populate matrix
    for i in 1..s_len
      for j in 1..t_len
        # critical comparison
        x1 = dm[i-1][j-1] + (self[j-1] == other[i-1] ? 0 : sub)
        x2 = dm[i][j-1] + ins
        x3 = dm[i-1][j] + del
        dm[i][j] = [x1, x2, x3].min
      end
    end

    # the last value in matrix is the Levenshtein distance between the strings
    dm[s_len][t_len]
  end
  
end
