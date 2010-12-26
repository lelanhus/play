class Shift < ActiveRecord::Base
  
  has_many :activities
  
  scope :complete, where("shifts.end_time IS NOT null")
  scope :incomplete, where("shifts.end_time IS null")
  
  validates :start_time,  :presence => true,
                          :timeliness => { :before => :end_time, :if => :has_end_time? }
                          
  validate :no_shifts_inprogress, :not_during_a_shift
  
  def self.between(one, two)
    where("shifts.start_time >= ? AND shifts.end_time <= ?", one, two)
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
    update_paid_hours
    update_nonpaid_hours
    update_total_hours
  end
  
  def update_paid_hours
    self.paid_hours = 0.0
    self.activities.paid.complete.each do |act|
      self.paid_hours += act.total_time
    end
  end
  
  def update_nonpaid_hours
    self.nonpaid_hours = 0.0
    self.activities.nonpaid.complete.each do |act|
      self.nonpaid_hours += act.total_time
    end
  end
  
  def update_total_hours
    self.total_hours = 0.0
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
