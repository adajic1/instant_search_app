class LevensteinService
  
  # Just passing values to initialize, then calling .call method
  # * *Args*    :
  #   - +target+ -> target string for Levenstein distance calculation
  #   - +source+ -> source string for Levenstein distance calculation
  #   - +ins+ -> cost value of char insertion
  #   - +del+ -> cost value of char deletion
  #   - +sub+ -> cost value of char substitution
  # * *Returns* :
  #   - Levenstein distance in form of array 1x3: [insertions, deletions, substitutions]. 
  #   - You can sum those 3 values to get total Levenstein distance.
  def self.call(target, source, ins=1, del=1, sub=1)
    # ins, del, sub are weighted costs
    new(target, source, ins, del, sub).call
  end
  
  # Calculate Levenstein distance between strings with weighted costs.
  # Separately store deletions, insertions and substitutions.
  # * *Returns* :
  #   - Levenstein distance in form of array 1x3: [insertions, deletions, substitutions]. 
  #   - You can sum those 3 values to get total Levenstein distance.
  def call
    return nil if (@target.nil? || @source.nil?)
    
    t_len = @target.length
    s_len = @source.length
    dm = Array.new(s_len+1) { Array.new(t_len+1) {[0, 0, 0]}} # distance matrix, dimension (s_len+1)x(t_len+1)x(3)
    
    # initialize first row   
    for j in 1..t_len
      dm[0][j][0] = j * @ins
    end
    
    # initialize first column
    for i in 1..s_len
      dm[i][0][1] = i * @del
    end 
    
    # populate matrix
    for i in 1..s_len
      for j in 1..t_len
        # critical comparison
        subCost = (@target[j-1] == @source[i-1] ? 0 : @sub)
        x1 = dm[i-1][j-1].sum + subCost
        x2 = dm[i][j-1].sum + @ins
        x3 = dm[i-1][j].sum + @del
        if x1<=x2 && x1<=x3
          # substitution
          dm[i][j] = dm[i-1][j-1].clone
          dm[i][j][2] += subCost
        elsif x2<=x1 && x2<=x3
          # insertion
          dm[i][j] = dm[i][j-1].clone
          dm[i][j][0] += @ins
        else
          # deletion
          dm[i][j] = dm[i-1][j].clone
          dm[i][j][1] += @del
        end
      end
    end

    # the last value in matrix is the Levenshtein distance between the strings
    dm[s_len][t_len]
    # prettyPrintMatrix(dm)
  end
  
  private
  
  # Initialize instance variables: @target, @source, @ins, @del, @sub
  def initialize(target, source, ins=1, del=1, sub=1)
    @target = target # target string
    @source = source # source string
    @ins = ins # weighted cost of insertion
    @del = del # weighted cost of deletion
    @sub = sub # weighted cost of substitution
  end
  
  # Pretty print matrix
  def prettyPrintMatrix(dm)
    for i in 0..dm.length - 1
      puts dm[i].inspect
    end
  end
  
end
