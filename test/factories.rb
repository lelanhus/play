Factory.define :activity do |f|
  f.start_time Time.now
end

Factory.define :full_activity, :class => Activity do |f|
  @start = Time.now
  @end = @start + 5000
  f.start_time @start
  f.end_time @end
end

Factory.define :paid_activity, :class => Activity do |f|
  @start = Time.now
  @end = @start + 5000
  f.start_time @start
  f.end_time @end
  f.paid true
end

# Shift Factories
Factory.define :shift do |f|
  f.start_time Time.now
end

Factory.define :full_shift, :class => Shift do |f|
  @start = Time.now
  @end = @start + 10000
  f.start_time @start
  f.end_time @end
end
