class Shift < ActiveRecord::Base
  
  has_many :activities
  
  validates :start_time, :presence => true
  validates :start_time, :timeliness => { :before => :end_time, :if => :end_time_present? }
  
  def end_time_present?
    !end_time.nil?
  end
end
