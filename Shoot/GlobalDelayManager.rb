class GlobalDelayManager
  def initialize
    @time = 0
  end

  def update
    return if @time == 0
    @time -= 1 if @time > 0
  end

  def check_time(time_value, &block)
    return if @time > 0

    yield if block_given?
    @time = time_value
  end
end