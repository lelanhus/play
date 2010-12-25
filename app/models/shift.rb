class Shift < ActiveRecord::Base
  
  has_many :activities
  
  validates :start_time,  :presence => true,
                          :timeliness => { :before => :end_time, :if => :has_end_time? }
  

  def has_end_time?
    !end_time.nil?
  end
end
