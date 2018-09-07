require_relative "../test_helper"

class UserActionTest < ActiveSupport::TestCase
  def setup
    ip_body = "127.255.255.255"
    @session = Session.get_or_create(ip_body)  
  end

  def teardown
    ## Nothing really
  end

  def test_register_type_search
    @old_query = ""
    @new_query = "test" 
    assert_equal(false, @session.last_user_action_is_search?) 
    UserAction.register_type_search(@session, @old_query, @new_query) 
    assert_equal(true, @session.last_user_action_is_search?) 
  end
end
