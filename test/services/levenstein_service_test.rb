require_relative "../test_helper"

class LevensteinServiceTest < ActiveSupport::TestCase
  def setup
    # 
  end

  def teardown
    ## Nothing really
  end

  def test_call
    @target_string = "2345678900"
    @source_string = "123756789" 
    levenstein_object = LevensteinService.call(@target_string, @source_string)
    assert_equal(2, levenstein_object.number_of_insertions) 
    assert_equal(1, levenstein_object.number_of_deletions) 
    assert_equal(1, levenstein_object.number_of_substitutions) 
    assert_equal(4, levenstein_object.levenstein_distance) 
  end
end