class CreateIncidents < ActiveRecord::Migration[8.0]
  def change
    create_table :incidents do |t|
      t.string :title, null: false
      t.text :description
      t.string :severity
      t.string :status, default: 'active'
      t.string :creator_name
      t.string :creator_id
      t.string :slack_channel_id
      t.datetime :started_at
      t.datetime :resolved_at

      t.timestamps
    end

    add_index :incidents, :status
  end
end
