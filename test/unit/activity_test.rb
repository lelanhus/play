require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  
  setup do
    Activity.destroy_all
  end
  
  teardown do
    Activity.destroy_all
  end
  
  test "activity should be invalid without a shift" do
    assert !Factory.build(:activity).valid?
  end
  
  test "activity should be invalid without start time" do
    act = Factory(:activity, :shift => Factory(:shift))
    act.start_time = nil
    assert !act.valid?
  end
  
  test "activity should be invalid if start time is after end time" do
    act = Factory.build(:activity, :shift => Factory(:shift))
    act.end_time = act.start_time - 5000
    assert !act.valid?
  end
  
  test "has_end_time? should return false when end time is not present" do
    act = Factory.build(:activity, :end_time => nil, :shift => Factory(:shift))
    assert_equal act.has_end_time?, false
  end
  
  test "has_end_time? should return true when end time is present" do
    act = Factory.build(:activity, :shift => Factory(:shift))
    assert_equal act.has_end_time?, true
  end
  
  test "calculate_total_time should calculate the total activty time to the first decimal" do
    act = Factory.build(:activity, :shift => Factory(:shift))
    act.end_time = act.start_time + 5000
    assert_equal act.calculate_total_time, 3.5
    
    a = Factory.build(:activity, :shift => Factory(:shift))
    a.end_time = a.start_time + 10000
    assert_equal a.calculate_total_time, 6.9
  end
  
  test "paid scope returns paid activities" do
    Activity.delete_all
    3.times do
      Factory(:activity, :paid => true, :shift => Factory(:shift))
    end
    Factory(:activity, :shift => Factory(:shift))
    assert_equal Activity.paid.length, 3
  end
  
  test "nonpaid scope returns nonpaid activities" do
    Activity.delete_all
    3.times do
      Factory(:activity, :shift => Factory(:shift))
    end
    Factory(:activity, :paid => true, :shift => Factory(:shift))
    assert_equal Activity.nonpaid.length, 3  
  end
  
  test "complete scope returns complete activities" do
    Activity.delete_all
    3.times do
      Factory(:activity, :shift => Factory(:shift))
    end
    Factory(:activity, :end_time => nil, :shift => Factory(:shift, :end_time => nil))
    assert_equal Activity.complete.length, 3
  end
  
  test "incomplete scope returns incomplete activities" do
    Activity.delete_all
    3.times do
      Factory(:activity, :shift => Factory(:shift))
    end
    Factory(:activity, :end_time => nil, :shift => Factory(:shift, :end_time => nil))
    assert_equal Activity.incomplete.length, 1
  end
  
  test "activity should occur during a shift" do
    act = Factory(:activity, :shift => Factory(:shift))
    act.start_time = act.shift.start_time - 50
    assert !act.valid?
    
    act.start_time = act.shift.start_time + 55
    act.end_time = act.shift.end_time + 50
    assert !act.valid?
  end

  test "activity should not occur during another activity of that shift" do
    shift1 = Factory(:shift)
    
    act1 = shift1.activities.build
    act1.start_time = shift1.start_time + 100
    act1.end_time = act1.start_time + 100
    act1.save
    
    # start time is during another activity
    act2 = shift1.activities.build
    act2.start_time = act1.start_time + 50
    act2.end_time = act1.end_time + 50
    assert !act2.valid?
    
    # end time is during another activity
    act2.start_time = act1.start_time - 50
    act2.end_time = act1.end_time - 50
    assert !act2.valid?
    
    shift2 = Factory(:shift)
    act = shift2.activities.build
    act.start_time = shift2.start_time + 100
    act.end_time = shift2.end_time - 100
    assert act.valid?
  end
  
  test "activity should have an end time if the shift is complete" do
    act = Factory(:activity, :shift => Factory(:shift))
    act.end_time = nil
    assert !act.valid?
  end
  
  test "a new activity cannot be started if there are incomplete activities for the shift" do
    act1 = Factory(:activity, :end_time => nil, :shift => Factory(:shift, :end_time => nil))
    act2 = act1.shift.activities.build
    act2.start_time = Time.now
    assert !act2.valid?
    
    Shift.destroy_all
    Activity.destroy_all
    act1 = Factory(:activity, :shift => Factory(:shift, :end_time => nil))
    act2 = act1.shift.activities.build
    act2.start_time = act1.end_time + 1
    assert act2.valid?
  end

  test "completing and activity updates shift activities count and hours" do
    Activity.destroy_all
    Shift.destroy_all
    act = Factory(:activity, :shift => Factory(:shift, :end_time => nil))
    assert_equal act.shift.activities.nonpaid.complete.length, 1
    assert_equal act.shift.nonpaid_activities, 1
    
    assert_equal act.shift.nonpaid_hours, act.total_time
    assert_equal act.shift.total_hours, act.total_time
    
    act2 = Factory(:activity, :paid => true, :shift => act.shift)
    assert_equal act2.shift.paid_activities, 1
    assert_equal act2.shift.nonpaid_activities, 1
    
    assert_equal act2.shift.nonpaid_hours, act.total_time
    assert_equal act2.shift.paid_hours, act2.total_time
    
    total_time = act.total_time + act2.total_time
    assert_equal act2.shift.total_hours, total_time
    
    shift = act.shift
    shift.end_time = Time.now + 30000
    act3 = Factory(:activity, :shift => shift)
    total_time = act.total_time + act2.total_time + act3.total_time
    assert_equal act3.shift.nonpaid_hours, total_time
    assert_equal act3.shift.nonpaid_activities, 2
  end
end
