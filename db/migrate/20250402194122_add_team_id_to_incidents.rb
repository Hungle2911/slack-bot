class AddTeamIdToIncidents < ActiveRecord::Migration[8.0]
  def change
    add_column :incidents, :team_id, :string
  end
end
