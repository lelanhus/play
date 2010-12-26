class Timesheet < ActiveRecord::Base
  
  has_many :shifts
  
  validates :start_date, :end_date, :paid_hours, :nonpaid_hours, :total_hours,
            :paid_activities, :nonpaid_activities, :presence => true
            
  validates :start_date, :timeliness => { :before => :end_date }
  
  after_save :update_shifts, :if => :needs_to_update_shifts?
  #after_save :update_hours_and_activities, :if => :needs_updated_activities?
  
  private
  
  def needs_updated_activities?
    return true if self.shifts_changed?
  end
  
  def needs_to_update_shifts?
    return true if self.start_date_changed? || self.end_date_changed?
  end

  def update_hours_and_activities
    pact = self.shifts.sum(:paid_activities)
    #self.update_attributes(:paid_activities => pact)
  end
  
  def update_shifts
    Shift.add_timesheet(self)
    update_hours_and_activities
  end
end
