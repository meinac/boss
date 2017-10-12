module WithTimeZone

  def with_time_zone(timezone, &block)
    current_timezone = ENV['TZ']
    ENV['TZ']        = timezone
    block.call
  ensure
    ENV['TZ'] = current_timezone
  end

end
