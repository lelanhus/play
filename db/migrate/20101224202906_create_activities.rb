class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.float :total_time, :default => 0.0
      t.boolean :paid, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
