class JawboneFormatting
  def initialize
  end

  def self.format_seconds(seconds)
    mm, ss = seconds.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)

    format = ""
    format += "#{dd}d " unless dd == 0
    format += "#{hh}h " unless hh == 0
    format += "#{mm}m " unless mm == 0
    format
  end

  def self.format_delimiter(number)
    parts = number.to_s.split('.')
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
    parts[0]
  end
end
