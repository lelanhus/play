class CreateShifts < ActiveRecord::Migration
  def self.up
    create_table :shifts do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.float :paid_hours, :default => 0.0
      t.float :nonpaid_hours, :default => 0.0
      t.float :total_hours, :default => 0.0
      t.integer :nonpaid_activities, :default => 0
      t.integer :paid_activities, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :shifts
  end
end
