class Article < ApplicationRecord
  
  def self.get_relevant_articles(query_string)
    # Shuffles array of articles and takes first 10 of them (at most)
    Article.all.to_a.shuffle[0,10] 
  end
  
end
