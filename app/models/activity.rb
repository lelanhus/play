class Activity < ActiveRecord::Base
  
  belongs_to :shift
  
  scope :paid, where(:paid => true)
  scope :nonpaid, where(:paid => false)
  scope :complete, where("activities.end_time is not null")
  
  validates :shift, :presence => true
  
  validates :start_time, :timeliness => { 
                                        :before => :end_time, :if => :has_end_time?, 
                                        :after => :shift_start
                                        }
  
  
  validates :end_time, :timeliness => {
                                      :before => :shift_end, :if => :has_end_time?
                                      }
                                      
  validate :not_between_others, :unless => Proc.new { |a| a.shift.blank? }

  before_validation :set_total_time, :if => :needs_total_time?
  
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
  
  def set_total_time
    total_time = calculate_total_time
  end
  
  private
  
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
  
  def not_between_others
    all_activities = self.shift.activities
    all_activities.delete(self)
    all_activities.each do |act|
      errors.add(:start_time, "can't be during another activity.") if
        act.start_time < self.start_time && self.start_time < act.end_time
        
      errors.add(:end_time, "can't be during another activity.") if
        act.start_time < self.end_time && self.end_time < act.end_time
    end
  end

  
end
