require_relative "../test_helper"

class AnalyticTest < ActiveSupport::TestCase
  
  def setup
    @session = Session.get_or_create("127.255.255.255")    
  end

  def teardown
    ## Nothing really
  end

  def test_handle_counter
    @old_query = ""
    @new_query = "test" 
    $stdout.puts "HHHHHHHHH"
    Analytic.handle_counter(@session, @old_query, @new_query)
    
    #db_record = Analytic.find_by_search_query(@new_query)
    #puts db_record.inspect

    # assert_equal(4, @num.add(2) )
  end

end
