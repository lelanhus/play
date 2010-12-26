Factory.define :activity do |f|
  @start = Time.now + 500 * rand()
  @end = @start + 1800 * rand()
  f.start_time @start
  f.end_time @end
end

Factory.define :shift do |f|
  @start = Time.now
  @end = @start + 15000 * rand()
  f.start_time @start
  f.end_time @end
end

Factory.define :timesheet do |f|
  @start = Time.now - 1.week
  @end = @start + 2.weeks
  f.start_date @start
  f.end_date @end
end