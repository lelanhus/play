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
  
  test "complete scope returns complete activities" do
    3.times do
      Factory(:shift)
    end
    Factory(:shift, :end_time => nil)
    assert_equal Shift.complete.length, 3
  end
  
  test "incomplete scope returns incomplete activities" do
    3.times do
      Factory(:shift)
    end
    Factory(:shift, :end_time => nil)
    assert_equal Shift.incomplete.length, 1
  end
  
  test "shift should not start if there are incomplete shifts" do
    Factory(:shift, :end_time => nil)
    assert !Factory.build(:shift).valid?
    
    Shift.destroy_all
    Factory(:shift)
    assert Factory.build(:shift).valid?
  end
  
  test "shift should not occur during another shift" do
    shift = Factory(:shift)
    s = Factory.build(:shift)
    s.start_time = shift.start_time + 10
    assert !s.valid?
    
    s.start_time = shift.start_time - 100
    s.end_time = shift.end_time - 100
    assert !s.valid?
    
    s.end_time = shift.start_time - 10
    assert s.valid?
  end

  test "update_activities updates activity counts and hours" do
    shift = Factory(:shift)
    3.times do
      Factory(:activity, :paid => true, :total_time => 3.0, :shift => shift)
    end
    
    shift.update_activities
    assert_equal shift.paid_activities, 3
    assert_equal shift.paid_hours, 9.0
    
    5.times do
      Factory(:activity, :total_time => 5.0, :shift => shift)
    end
    
    shift.update_activities
    assert_equal shift.nonpaid_activities, 5
    assert_equal shift.nonpaid_hours, 25.0
    
    assert_equal shift.total_hours, 34.0
    
  end

  test "scope between returns all shifts between two dates" do
    shift1 = Factory(:shift)
    shift2 = Factory(:shift)
    shift3 = Factory(:shift)
    
    shift2.start_time = shift2.start_time + 2.years
    shift2.end_time = shift2.end_time + 2.years
    shift2.save
    
    shift3.start_time = shift3.start_time + 2.weeks
    shift3.end_time = shift3.end_time + 2.weeks
    shift3.save
    
    time1 = Time.now - 1.week
    time2 = Time.now + 1.day
    assert_equal Shift.between(time1, time2).count, 1
    
    time2 = Time.now + 3.weeks
    assert_equal Shift.between(time1, time2).count, 2
    
    time2 = Time.now + 3.years
    assert_equal Shift.between(time1, time2).count, 3
  end
end
