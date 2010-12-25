require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  
  setup do
    Shift.destroy_all
  end
  
  teardown do
    Shift.destroy_all
  end
  
  test "should be invalid without start time" do
    assert !Factory.build(:shift, :start_time => nil).valid?
  end
  
  test "should be invalid if start time is after end time" do
    act = Factory.build(:shift)
    act.end_time = act.start_time - 5000
    assert !act.valid?
  end
  
  test "has_end_time? should return false when end time is not present" do
    act = Factory.build(:shift, :end_time => nil)
    assert_equal act.has_end_time?, false
  end
  
  test "has_end_time? should return true when end time is present" do
    act = Factory.build(:shift)
    assert_equal act.has_end_time?, true
  end
  
  test "shift should not start if there are incomplete shifts" do
    
  end
  
  test "shift should not occur during another shift" do
    
  end
  
  
end
