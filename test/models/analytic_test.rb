require_relative "../test_helper"

class AnalyticTest < ActiveSupport::TestCase
  
  def setup
    @session = Session.get_or_create("127.255.255.255")   
  end

  def teardown
    ## Nothing really
  end

  def test_handle_counters_based_on_query_type
    @old_query = ""
    @new_query = "test" 
    
    # Test if counter increased by 1
    Analytic.handle_counters_based_on_query_type(@session, @old_query, @new_query)    
    db_record = Analytic.find_by_search_query(@new_query)
    assert_equal(3, db_record.counter)      
  end

end
