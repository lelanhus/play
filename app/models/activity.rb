class Activity < ActiveRecord::Base
  
  belongs_to :shift
  
  scope :paid, where(:paid => true)
  scope :nonpaid, where(:paid => false)
  scope :complete, where("activities.end_time is not null")
  scope :incomplete, where("activities.end_time is null")
  
  validates :shift_id, :presence => true
  
  validates :start_time, :timeliness => { 
                                        :before => :end_time, :if => :has_end_time?, 
                                        :after => :shift_start
                                        }
  
  validates :end_time, :timeliness => {
                                      :before => :shift_end, :if => :shift_complete?
                                      }
                                      
  validates :end_time, :presence => true, :if => :shift_complete?
                                      
  validate :proper_shift, :unless => Proc.new { |a| a.shift.blank? }

  before_validation :set_total_time, :if => :needs_total_time?
  
  def shift_complete?
    return false if self.shift_id.nil?
    !self.shift.end_time.nil?
  end
  
  def shift_start
    self.shift.start_time
  end
  
  def shift_end
    self.shift.end_time
  end
  
  def has_end_time?
    !end_time.nil?
  end
  
  def calculate_total_time
    diff = end_time - start_time
    round(diff, 1)
  end
  
  def current_activities?
    !self.shift.activities.incomplete.empty?
  end
  
  private
  
  
  def set_total_time
    total_time = calculate_total_time
  end
  
  def needs_total_time?
    return true if has_end_time? and !start_time.nil?
    false
  end
  
  def round(time, decimals)
    exp = 10.0**decimals
    a = in_hours(time) * exp
    b = a.round
    c = b / exp
    c
  end
  
  def in_hours(time)
    time / 60 / 24
  end
  
  def proper_shift
    return inprogress_activities if current_activities?
    not_between_others
  end
  
  def inprogress_activities
    errors.add(:start_time, "can't happen when there are activities in progress.")
  end
  
  def not_between_others
    all_activities = self.shift.activities.complete
    all_activities.delete(self)
    all_activities.each do |act|
      errors.add(:start_time, "can't be during another activity.") if
        compare_start(act.start_time) && compare_end(act.end_time)
        
      errors.add(:end_time, "can't be during another activity.") if
        compare_start(act.start_time, true) && compare_end(act.end_time, true)
    end
  end
  
  def compare_start(time, the_end = false)
    return false if self.end_time.nil?
    return time < self.end_time if the_end == true
    time < self.start_time
  end
  
  def compare_end(time, the_end = false)
    return self.start_time < time unless the_end == true
    self.end_time < time
  end

  
end
