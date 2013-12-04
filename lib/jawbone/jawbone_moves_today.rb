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
    format_delimiter(@activity["details"]["bmr"] + @activity["details"]["calories"])
  end

  def active_burn
    format_delimiter(@activity["details"]["calories"])
  end

  def resting_burn
    format_delimiter(@activity["details"]["bmr"])
  end

  def active
    format_seconds(@activity["details"]["active_time"])
  end

  def longest_active
    format_seconds(@activity["details"]["longest_active"])
  end

  def longest_idle
    format_seconds(@activity["details"]["longest_idle"])
  end

  def snapshot
    "http://jawbone.com/#{@activity["snapshot_image"]}"
  end

  def format_delimiter(number)
    parts = number.to_s.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
    parts[0]
  end

  def format_seconds(seconds)
    mm, ss = seconds.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    format = ""
    format += "#{dd}d "  unless dd == 0
    format += "#{hh}h " unless hh == 0
    format += "#{mm}m " unless mm == 0
    format += "#{ss}s " unless ss == 0
    format
  end
end
