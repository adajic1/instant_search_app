require_relative "../test_helper"

class SearchQueryTest < ActiveSupport::TestCase
  def setup
    @session = Session.get_or_create("127.255.255.255") 
    # Note that query type depends on @session.user_actions.last, as well as @old_query, @new_query
  end

  def teardown
    ## Nothing really
  end

  def test_get_relevant_articles
    @old_query = ""
    @new_query = "test" 
    
    # Test type of search query
    query_type = SearchQuery.get_type_of_search_query(@session, @old_query, @new_query)    
    assert_equal(SearchQuery::QUERY_TYPE_NEW, query_type)  
    # This is considered QUERY_TYPE_NEW because last user action of this session is not a search.
    # If it was and it fitted @old_query then it would be considered as QUERY_TYPE_UPDATE.
  end
end
