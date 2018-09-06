class Article < ApplicationRecord
  
  def self.get_relevant_articles(query_string)
    Article.all.to_a
  end
  
end
