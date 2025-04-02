class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :team_id
      t.string :team_name
      t.string :access_token
      t.string :bot_user_id

      t.timestamps
    end
  end
end
