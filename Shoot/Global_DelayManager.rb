class Global_DelayManager
  TIME_COUNT = 100

  attr_reader :current_time

  def initialize
    @counter = TIME_COUNT
  end

  def update
    @counter -=1
    @counter = TIME_COUNT if @counter == 0
  end

  def check_time(seconds, flag_list, flag_name, &block)
    if seconds.include?(@counter)
      yield if block_given?
      flag_list[flag_name] = true if !flag_list[flag_name]
    else
      flag_list[flag_name] = false if flag_list[flag_name]
    end
  end
end