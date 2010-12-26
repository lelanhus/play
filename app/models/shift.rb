class Shift < ActiveRecord::Base
  
  has_many :activities
  
  belongs_to :timesheet
  
  scope :complete, where("shifts.end_time IS NOT null")
  scope :incomplete, where("shifts.end_time IS null")
  
  validates :start_time,  :presence => true,
                          :timeliness => { :before => :end_time, :if => :has_end_time? }
                          
  validate :no_shifts_inprogress, :not_during_a_shift
  
  def self.between(one, two)
    where("shifts.start_time >= ? AND shifts.start_time <= ?", one, two)
  end
  
  def self.add_timesheet(timesheet)
    shifts = Shift.between(timesheet.start_date, timesheet.end_date)
    shifts.each do |s|
      s.update_attributes(:timesheet_id => timesheet.id)
    end
  end
  
  def update_activities
    update_activity_count
    update_activity_hours
    save
  end
  
  def shift_inprogress?
    !Shift.incomplete.empty?
  end

  def has_end_time?
    !end_time.nil?
  end
  
  private
  
  def update_activity_count
    self.paid_activities = self.activities.paid.count
    self.nonpaid_activities = self.activities.nonpaid.count
  end
  
  def update_activity_hours
    acts = self.activities.complete
    self.paid_hours = acts.paid.sum(:total_time)
    self.nonpaid_hours = acts.nonpaid.sum(:total_time)
    self.total_hours = self.paid_hours + self.nonpaid_hours
  end
  
  def no_shifts_inprogress
    errors.add(:start_time, "can't happen if there are shifts in progress.") if
      shift_inprogress?
  end
  
  def not_during_a_shift
    Shift.complete.each do |shift|
      return errors.add(:start_time, "can't occur during another shift.") if 
        shift.start_time < self.start_time && self.start_time < shift.end_time
        
      unless self.end_time.nil?
        return errors.add(:end_time, "can't occur during another shift.") if
          shift.start_time < self.end_time && self.end_time < shift.end_time
      end
    end
  end
end
