class Article < ApplicationRecord
  
  def self.get_relevant_articles(query_string)
    # Shuffles array of received records and takes at most first 10 of them
    Article.all.to_a.shuffle[0,10] 
  end
  
end
