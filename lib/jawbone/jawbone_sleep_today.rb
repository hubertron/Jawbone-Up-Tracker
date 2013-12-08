require 'jawbone/jawbone_formatting'

class JawboneSleepToday
  def initialize(activity)
    @activity = activity
  end

  def date
    DateTime.parse("#{@activity["date"]}").strftime("%m/%d/%Y")
  end

  def started_at
    Time.at(@activity["time_created"]).strftime("%l:%M%P")
  end

  def ended_at
    Time.at(@activity["time_completed"]).strftime("%l:%M%P")
  end

  def light_sleep
    JawboneFormatting.format_seconds(@activity["details"]["light"])
  end

  def deep_sleep
    JawboneFormatting.format_seconds(@activity["details"]["deep"])
  end

  def awake
    JawboneFormatting.format_seconds(@activity["details"]["awake"])
  end

  def awake_time
    Time.at(@activity["details"]["awake_time"]).strftime("%l:%M%P")
  end

  def asleep_time
    Time.at(@activity["details"]["asleep_time"]).strftime("%l:%M%P")
  end

  def duration
    JawboneFormatting.format_seconds(@activity["details"]["duration"])
  end

  def fell_asleep_in
    started = Time.at(@activity["time_created"])
    asleep  = Time.at(@activity["details"]["asleep_time"])
    "#{TimeDifference.between(started, asleep).in_minutes.to_i}m"
  end

  def snapshot
    "http://jawbone.com/#{@activity["snapshot_image"]}"
  end
end
