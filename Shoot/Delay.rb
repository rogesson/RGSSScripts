class Delay
  INITIAL_COUNT = 0

  def initialize(time)
    @initial_count = INITIAL_COUNT
    @time = time
    @original_time = time
  end

  def update
    @initial_count += 1
  end

  def fire
    @initial_count >= @time
  end

  def reset
    @initial_count = INITIAL_COUNT
  end

  def reset_rand
    reset
    @time = @original_time
    @time += rand(20)
  end
end