Factory.define :activity do |f|
  @start = Time.now + 500
  @end = @start + 1800
  f.start_time @start
  f.end_time @end
end

Factory.define :shift do |f|
  @start = Time.now
  @end = @start + 15000
  f.start_time @start
  f.end_time @end
end