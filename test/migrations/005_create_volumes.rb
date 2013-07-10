class CreateVolumes < ActiveRecord::Migration
  def self.up
    puts "creating"
    create_table :volumes do |t|
      t.belongs_to :user
      t.timestamps
    end
  end
end