class CreateTimesheets < ActiveRecord::Migration
  def self.up
    create_table :timesheets do |t|
      t.date :start_date
      t.date :end_date
      t.float :paid_hours 
      t.float :nonpaid_hours 
      t.integer :total_hours 
      t.integer :paid_activities 
      t.integer :nonpaid_activities 
      t.timestamps
    end
    add_column :shifts, :timesheet_id, :integer
  end

  def self.down
    drop_table :timesheets
    remove_column :shifts, :timesheet_id
  end
end
