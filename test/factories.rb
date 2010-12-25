Factory.define :activity do |f|
  f.association :shift
  @start = Time.now
  @end = @start + 3600 * rand()
  f.start_time @start
  f.end_time @end
end

Factory.define :shift do |f|
  @start = Time.now
  @end = @start + 15000
  f.start_time @start
  f.end_time @end
end

Factory.define :extra_activity, :class => Activity do |f|
  @start = Time.now
  @end = @start + 5000
  f.start_time @start
  f.end_time @end
end