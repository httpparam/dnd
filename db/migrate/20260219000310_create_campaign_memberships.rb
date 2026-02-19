class CreateCampaignMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_memberships do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end

    add_index :campaign_memberships, [:campaign_id, :user_id], unique: true
  end
end
