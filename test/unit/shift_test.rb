require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  test "should be invalid without start time" do
    assert !Factory.build(:shift, :start_time => nil).valid?
  end
  
  test "should be invalid if start time is after end time" do
    act = Factory.build(:shift)
    act.end_time = act.start_time - 5000
    assert !act.valid?
  end
  
  test "end_time_present? should return false when end time is not present" do
    act = Factory.build(:shift, :end_time => nil)
    assert_equal act.end_time_present?, false
  end
  
  test "end_time_present? should return true when end time is present" do
    act = Factory.build(:full_shift)
    assert_equal act.end_time_present?, true
  end
end
