class LevensteinService
  
  # Constants
  INSERTION_COST = 1 # Weighted cost of insertion
  DELETION_COST = 1 # Weighted cost of deletion
  SUBSTITUTION_COST = 1 # Weighted cost of substitution
  
  # Attributes
  attr_reader :number_of_insertions, :number_of_deletions, :number_of_substitutions, :levenstein_distance
  
  # Just passing values to initialize, then calling .call method  
  def self.call(target_string, source_string)
    new(target_string, source_string).call
  end
  
  # Calculates Levenstein distance between strings with weighted costs.
  # Separately stores deletions, insertions, substitutions and levenstein distance as attributes.
  # * *Returns* :
  #   - self object
  #     After calling this method you can access attributes: 
  #     number_of_insertions, number_of_deletions, number_of_substitutions, levenstein_distance
  def call
    return nil if (@target_string.nil? || @source_string.nil?)
    
    target_length = @target_string.length
    source_length = @source_string.length
    
    dm = Array.new(source_length+1) { 
      Array.new(target_length+1) {[0, 0, 0]}
    } # distance matrix, dimension (source_length+1)x(target_length+1)x(3)
    
    # initialize first row   
    for j in 1..target_length
      dm[0][j][0] = j * INSERTION_COST
    end
    
    # initialize first column
    for i in 1..source_length
      dm[i][0][1] = i * DELETION_COST
    end 
    
    # populate matrix
    for i in 1..source_length
      for j in 1..target_length
        # critical comparison
        cost = (@target_string[j-1] == @source_string[i-1] ? 0 : SUBSTITUTION_COST)
        x1 = dm[i-1][j-1].sum + cost
        x2 = dm[i][j-1].sum + INSERTION_COST
        x3 = dm[i-1][j].sum + DELETION_COST
        if x1<=x2 && x1<=x3
          # substitution
          dm[i][j] = dm[i-1][j-1].clone
          dm[i][j][2] += cost
        elsif x2<=x1 && x2<=x3
          # insertion
          dm[i][j] = dm[i][j-1].clone
          dm[i][j][0] += INSERTION_COST
        else
          # deletion
          dm[i][j] = dm[i-1][j].clone
          dm[i][j][1] += DELETION_COST
        end
      end
    end

    # the last value in matrix is in form of an array: 
    # [number_of_insertions, number_of_deletions, number_of_substitutions]
    last_value = dm[source_length][target_length]
    @number_of_insertions = last_value[0]
    @number_of_deletions = last_value[1] 
    @number_of_substitutions = last_value[2]
    @levenstein_distance = last_value.sum
    # pretty_print_matrix(dm) 
    self      
  end
  
  private
  
  # Initialize instance variables
  def initialize(target_string, source_string)
    @target_string = target_string
    @source_string = source_string
  end
  
  # Pretty print matrix
  def pretty_print_matrix(dm)
    for i in 0..dm.length - 1
      puts dm[i].inspect
    end
  end
  
end
