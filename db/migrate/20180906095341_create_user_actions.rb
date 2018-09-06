class CreateUserActions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_actions do |t|
      t.string :action_type
      t.string :description
      t.references :session, foreign_key: true

      t.timestamps
    end
  end
end
