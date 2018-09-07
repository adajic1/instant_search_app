require_relative "../test_helper"

class SessionTest < ActiveSupport::TestCase
  def setup
    #  
  end

  def teardown
    ## Nothing really
  end

  def test_get_or_create
    ip_body = "127.255.255.255"
    @session = Session.get_or_create(ip_body) 
    assert_equal(ip_body, @session.body) # Test if it created session with given ip    
    assert_equal(3, Session.all.count) # There should be 3 sessions now (2 from fixtures)
  end
  
  def test_last_user_action_is_search?
    ip_body = "127.255.255.255"
    @session = Session.get_or_create(ip_body) 
    assert_equal(false, @session.last_user_action_is_search?)  
    
    @old_query = ""
    @new_query = "test" 
    UserAction.register_type_search(@session, @old_query, @new_query) 
    assert_equal(true, @session.last_user_action_is_search?) 
  end
   
end
