class AddShiftIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :shift_id, :integer
  end

  def self.down
    remove_column :activities, :shift_id
  end
end
