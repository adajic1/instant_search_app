class LevensteinService
  
  # Just passing values to initialize, then calling .call method
  # * *Args*    :
  #   - +target+ -> target string for Levenstein distance calculation
  #   - +source+ -> source string for Levenstein distance calculation
  #   - +insertion_cost+ -> cost value of char insertion
  #   - +deletion_cost+ -> cost value of char deletion
  #   - +substitution_cost+ -> cost value of char substitution
  # * *Returns* :
  #   - Levenstein distance in form of an array 1x3: 
  #   - [number_of_insertions, number_of_deletions, number_of_substitutions] 
  #   - You can sum those 3 values to get total Levenstein distance.
  def self.call(target, source, insertion_cost=1, deletion_cost=1, substitution_cost=1)
    new(target, source, insertion_cost, deletion_cost, substitution_cost).call
  end
  
  # Calculate Levenstein distance between strings with weighted costs.
  # Separately store deletions, insertions and substitutions.
  # * *Returns* :
  #   - Levenstein distance in form of an array 1x3: 
  #   - [number_of_insertions, number_of_deletions, number_of_substitutions] 
  #   - You can sum those 3 values to get total Levenstein distance.
  def call
    return nil if (@target.nil? || @source.nil?)
    
    target_length = @target.length
    source_length = @source.length
    dm = Array.new(source_length+1) { Array.new(target_length+1) {[0, 0, 0]}} 
    # distance matrix, dimension (source_length+1)x(target_length+1)x(3)
    
    # initialize first row   
    for j in 1..target_length
      dm[0][j][0] = j * @insertion_cost
    end
    
    # initialize first column
    for i in 1..source_length
      dm[i][0][1] = i * @deletion_cost
    end 
    
    # populate matrix
    for i in 1..source_length
      for j in 1..target_length
        # critical comparison
        subCost = (@target[j-1] == @source[i-1] ? 0 : @substitution_cost)
        x1 = dm[i-1][j-1].sum + subCost
        x2 = dm[i][j-1].sum + @insertion_cost
        x3 = dm[i-1][j].sum + @deletion_cost
        if x1<=x2 && x1<=x3
          # substitution
          dm[i][j] = dm[i-1][j-1].clone
          dm[i][j][2] += subCost
        elsif x2<=x1 && x2<=x3
          # insertion
          dm[i][j] = dm[i][j-1].clone
          dm[i][j][0] += @insertion_cost
        else
          # deletion
          dm[i][j] = dm[i-1][j].clone
          dm[i][j][1] += @deletion_cost
        end
      end
    end

    # the last value in matrix is the Levenshtein distance between the strings
    dm[source_length][target_length]
    # prettyPrintMatrix(dm)
  end
  
  private
  
  # Initialize instance variables: @target, @source, @ins, @del, @sub
  def initialize(target, source, insertion_cost=1, deletion_cost=1, substitution_cost=1)
    @target = target # target string
    @source = source # source string
    @insertion_cost = insertion_cost # weighted cost of insertion
    @deletion_cost = deletion_cost # weighted cost of deletion
    @substitution_cost = substitution_cost # weighted cost of substitution
  end
  
  # Pretty print matrix
  def prettyPrintMatrix(dm)
    for i in 0..dm.length - 1
      puts dm[i].inspect
    end
  end
  
end
