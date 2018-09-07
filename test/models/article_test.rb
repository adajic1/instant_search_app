require_relative "../test_helper"

class ArticleTest < ActiveSupport::TestCase
  def setup
    #   
  end

  def teardown
    ## Nothing really
  end

  def test_get_relevant_articles
    # Test if it retrieves fixtures (there are 2 articles there)
    articles = Article.get_relevant_articles("something")
    assert_equal(2, articles.count) 
  end
end
