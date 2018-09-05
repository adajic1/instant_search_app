class RenamePhraseColumn < ActiveRecord::Migration[5.2]
  def change
	rename_column :analytics, :phrase, :search_query
  end
end
