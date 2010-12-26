class Shift < ActiveRecord::Base
  
  has_many :activities
  
  scope :complete, where("shifts.end_time is not null")
  scope :incomplete, where("shifts.end_time is null")
  
  validates :start_time,  :presence => true,
                          :timeliness => { :before => :end_time, :if => :has_end_time? }
                          
  validate :no_shifts_inprogress, :not_during_a_shift
  
  def shift_inprogress?
    !Shift.incomplete.empty?
  end

  def has_end_time?
    !end_time.nil?
  end
  
  private
  
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
