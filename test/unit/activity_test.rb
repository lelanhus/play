require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  
  setup do
    Activity.destroy_all
  end
  
  teardown do
    Activity.destroy_all
  end
  
  test "should be invalid without start time" do
    assert !Factory.build(:activity, :start_time => nil).valid?
  end
  
  test "should be invalid if start time is after end time" do
    act = Factory.build(:activity)
    act.end_time = act.start_time - 5000
    assert !act.valid?
  end
  
  test "should be invalid without a shift" do
    
  end
  
  test "end_time_present? should return false when end time is not present" do
    act = Factory.build(:activity, :end_time => nil)
    assert_equal act.end_time_present?, false
  end
  
  test "end_time_present? should return true when end time is present" do
    act = Factory.build(:activity)
    assert_equal act.end_time_present?, true
  end
  
  test "calculate_total_time should calculate the total activty time to the first decimal" do
    act = Factory.build(:activity)
    act.end_time = act.start_time + 5000
    assert_equal act.calculate_total_time, 3.5
    
    a = Factory.build(:activity)
    a.end_time = a.start_time + 10000
    assert_equal a.calculate_total_time, 6.9
  end
  
  test "paid scope returns paid activities" do
    Activity.delete_all
    3.times do
      Factory(:activity, :paid => true)
    end
    Factory(:activity)
    assert_equal Activity.paid.length, 3
  end
  
  test "nonpaid scope returns nonpaid activities" do
    Activity.delete_all
    3.times do
      Factory(:activity)
    end
    Factory(:activity, :paid => true)
    assert_equal Activity.nonpaid.length, 3  
  end
  
  test "complete scope returns complete activities" do
    Activity.delete_all
    3.times do
      Factory(:activity)
    end
    Factory(:activity, :end_time => :nil)
    assert_equal Activity.complete.length, 3
  end
  
  test "start time should be during the shift" do

  end
end
