class CreateCampaignMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :campaign_messages do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :body, null: false
      t.timestamps
    end
  end
end
