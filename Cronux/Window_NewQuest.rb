class Window_NewQuest < Window_Base
  def initialize(quest)
    window_width  = 400
    window_height = 64

    window_x      = 320 - window_width  / 2
    window_y      = 240 - window_height / 2

    @time_to_die  = 180
    @time_counter = 0

    super(window_x, window_y, window_width, window_height)

    @quest = quest
    self.contents = Bitmap.new(width - 32, height - 32)
    draw_message
    self.active = true
  end

  def update
    return unless active

    super

    keep_alive? ? increment_counter : disappear
  end

  private

  def keep_alive?
    @time_counter < @time_to_die
  end

  def draw_message
    contents.draw_text(0, 0, 300, 32, "Nova Missão: #{@quest.name}")
  end

  def increment_counter
    @time_counter += 1
  end

  def reset_counter
    @time_counter = 0
  end

  def disappear
    self.active = false
    $scene.window_new_quest.dispose
    $scene.window_new_quest = nil
    reset_counter
  end
end