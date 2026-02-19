class AddQueueStatusToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :queued_for_matching, :boolean, default: false, null: false
    add_column :users, :queued_at, :datetime
  end
end
