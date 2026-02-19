class CreateCampaignJoinRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_join_requests do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.timestamps
    end

    add_index :campaign_join_requests, [:campaign_id, :user_id], unique: true
  end
end
