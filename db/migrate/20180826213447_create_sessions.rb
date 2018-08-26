class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.string :body
      t.string :lastpartial

      t.timestamps
    end
  end
end
