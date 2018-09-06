class UserAction < ApplicationRecord
  belongs_to :session
  
  # Constant strings defining actions
  TYPE_SEARCH = "searched article"
  TYPE_READ = "read article"
  TYPE_CLOSE_ARTICLE = "closed article"  
  TYPE_CLOSE_TAB = "closed tab"
  TYPE_SEARCH = "contacted support" 
end
