# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration
  # Create table
  def self.up
    create_table :activities do |t|
      t.belongs_to :actor,      :polymorphic => true
      t.belongs_to :act_object, :polymorphic => true
      t.belongs_to :act_target, :polymorphic => true

      t.string  :verb
      t.string  :reverses
      t.string  :description
      t.string  :options
      t.string  :bond_type

      t.timestamps
    end

    add_index :activities, [:verb]
    add_index :activities, [:actor_id, :actor_type]
    add_index :activities, [:act_object_id, :act_object_type]
    add_index :activities, [:act_target_id, :act_target_type]
  end
  # Drop table
  def self.down
    drop_table :activities
  end
end
