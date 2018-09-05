class CreateAnalytics < ActiveRecord::Migration[5.2]
  def change
    create_table :analytics do |t|
      t.string :search_query
      t.integer :counter

      t.timestamps
    end
  end
end
