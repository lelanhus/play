class Shift < ActiveRecord::Base
  
  validates :start_time, :presence => true
  validates_time :start_time, :before => :end_time, :if => :end_time_present?
  
  def end_time_present?
    !end_time.nil?
  end
end
