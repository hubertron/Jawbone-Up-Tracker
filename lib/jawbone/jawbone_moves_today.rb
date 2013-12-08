require 'jawbone/jawbone_formatting'

class JawboneMovesToday
  attr_accessor :activity

  def initialize(activity)
    @activity = activity
  end

  def started_at
    Time.at(@activity["time_created"]).strftime("%l:%M%P")
  end

  def ended_at
    Time.at(@activity["time_completed"]).strftime("%l:%M%P")
  end

  def steps
    @activity["details"]["steps"]
  end

  def date
    DateTime.parse("#{@activity["date"]}").strftime("%m/%d/%Y")
  end

  def miles
    "%0.2f" % (@activity["details"]["km"] * 0.621371)
  end

  def km
    "%0.2f" % (@activity["details"]["km"])
  end

  def total_burn
    JawboneFormatting.format_delimiter(@activity["details"]["bmr"] + @activity["details"]["calories"])
  end

  def active_burn
    JawboneFormatting.format_delimiter(@activity["details"]["calories"])
  end

  def resting_burn
    JawboneFormatting.format_delimiter(@activity["details"]["bmr"])
  end

  def active
    JawboneFormatting.format_seconds(@activity["details"]["active_time"])
  end

  def longest_active
    JawboneFormatting.format_seconds(@activity["details"]["longest_active"])
  end

  def longest_idle
    JawboneFormatting.format_seconds(@activity["details"]["longest_idle"])
  end

  def snapshot
    "http://jawbone.com/#{@activity["snapshot_image"]}"
  end
end
