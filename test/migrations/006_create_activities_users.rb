# Migration responsible for creating a table with activities
class CreateActivitiesUsers < ActiveRecord::Migration
  # Create table
  def self.up

    create_table :activities_users, :id => false do |t|
      t.references :activity, :user
    end

    add_index :activities_users, [:activity_id, :user_id ]

  end
  # Drop table
  def self.down
    drop_table :activities_users
  end
end
