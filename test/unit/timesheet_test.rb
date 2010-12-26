require 'test_helper'

class TimesheetTest < ActiveSupport::TestCase
  
  setup do
    Timesheet.destroy_all
  end
  
  teardown do
    Timesheet.destroy_all
  end
  
  test "should be invalid without all attributes" do
    assert !Factory.build(:timesheet, :start_date => nil).valid?
    assert !Factory.build(:timesheet, :end_date => nil).valid?
    assert !Factory.build(:timesheet, :paid_hours => nil).valid?
    assert !Factory.build(:timesheet, :nonpaid_hours => nil).valid?
    assert !Factory.build(:timesheet, :total_hours => nil).valid?
    assert !Factory.build(:timesheet, :paid_activities => nil).valid?
    assert !Factory.build(:timesheet, :nonpaid_activities => nil).valid?
    assert Factory.build(:timesheet).valid?
  end
  
  test "start should be before end" do
    t = Factory.build(:timesheet)
    t.start_date = t.start_date + 1.month
    assert !t.valid?
  end
  
  test "a timesheet should include all shifts within it's date range" do
    shift1 = Factory(:shift)
    new_start = Time.now + 1.day
    new_end = Time.now + 1500 + 1.day
    shift2 = Factory(:shift, :start_time => new_start, :end_time => new_end)
    
    sheet_start = Time.now - 1.day
    sheet_end = Time.now + 2.weeks
    
    sheet = Factory(:timesheet, :start_date => sheet_start, :end_date => sheet_end)
    
    assert_equal sheet.shifts.count, 2
  end

  test "totals get updated when created" do
    Activity.destroy_all
    Shift.destroy_all
    Timesheet.destroy_all
    
    s1 = Factory(:shift)
    s2 = Factory(:shift)
    act1 = Factory(:activity, :paid => true, :shift => s1)
    act2 = Factory(:activity, :shift => s1)
    act3 = Factory(:activity, :paid => true, :shift => s2)
    act4 = Factory(:activity, :shift => s2)
    sheet = Factory(:timesheet)
    
    paid_hours = 25.0
    nonpaid_hours = 40.0
    total_hours = paid_hours + nonpaid_hours
    
    s1.update_attributes(:paid_hours => paid_hours, :nonpaid_hours => nonpaid_hours, :total_hours => total_hours)
    s2.update_attributes(:paid_hours => paid_hours, :nonpaid_hours => nonpaid_hours, :total_hours => total_hours)
        
    #assert_equal sheet.shifts.count, 2
    #assert_equal sheet.paid_activities, 2
    #assert_equal sheet.nonpaid_activities, 2
    #assert_equal sheet.paid_hours, 50.0
    #assert_equal sheet.nonpaid_hours, 80.0
    #assert_equal sheet.total_hours, 130.0
  end

end
