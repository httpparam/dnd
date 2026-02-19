class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :hackclub_id, null: false
      t.string :name
      t.string :email
      t.string :avatar_url
      t.string :experience_level
      t.boolean :dm_experience, default: false, null: false
      t.string :roles, array: true, default: []
      t.string :styles, array: true, default: []
      t.string :atmospheres, array: true, default: []
      t.jsonb :availability, default: {}

      t.timestamps
    end

    add_index :users, :hackclub_id, unique: true
  end
end
