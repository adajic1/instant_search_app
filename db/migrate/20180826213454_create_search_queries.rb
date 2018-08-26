class CreateSearchQueries < ActiveRecord::Migration[5.2]
  def change
    create_table :search_queries do |t|
      t.string :body
      t.references :session, foreign_key: true

      t.timestamps
    end
  end
end
