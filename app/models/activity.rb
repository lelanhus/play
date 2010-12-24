class Activity < ActiveRecord::Base
  
  
  validates :start_time, :presence => true
  validates_time :start_time, :before => :end_time, :if => :end_time_present?
  validates :total_time, :presence => true
  
  before_validation :set_total_time, :if => :needs_total_time?
  
  def end_time_present?
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
    return true if end_time_present? and !start_time.nil?
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
  
end
