class CreateCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns do |t|
      t.string :title, null: false
      t.references :dm, foreign_key: { to_table: :users }
      t.integer :players_count, default: 0, null: false
      t.string :status, default: "Forming", null: false
      t.string :needs, array: true, default: []
      t.string :atmosphere
      t.string :start_time

      t.timestamps
    end
  end
end
