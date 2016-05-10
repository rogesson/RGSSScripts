class Window_QuestMessages < Window_Base

  attr_reader :new_quest

  def initialize(quest, new_quest)
    window_width  = 400
    window_height = 64

    window_x      = 320 - window_width  / 2
    window_y      = 240 - window_height / 2

    @time_to_die  = 98
    @time_counter = 0

    @new_quest = new_quest

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
    message = new_quest ? "Nova Missão (#{@quest.name})" : "Missão (#{@quest.name}) concluída"

    contents.draw_text(0, 0, 300, 32, message)
  end

  def increment_counter
    @time_counter += 1
    fade_in
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

  def fade_in
    self.y -= 0.7
    self.opacity -= 1.8
  end
end