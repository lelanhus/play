class CreateTimesheets < ActiveRecord::Migration
  def self.up
    create_table :timesheets do |t|
      t.date :start_date
      t.date :end_date
      t.float :paid_hours, :default => 0.0
      t.float :nonpaid_hours, :default => 0.0
      t.integer :total_hours, :default => 0.0
      t.integer :paid_activities, :default => 0
      t.integer :nonpaid_activities, :default => 0
      t.timestamps
    end
    add_column :shifts, :timesheet_id, :integer
  end

  def self.down
    drop_table :timesheets
    remove_column :shifts, :timesheet_id
  end
end
