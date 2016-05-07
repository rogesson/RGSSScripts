class Window_NavQuest < Window_Base
  def initialize
    super(380, 220, 260, 300)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.active = true
    self.opacity = 0
  end

  def update
    draw_quests
    self.active = false
  end

  def draw_quests
    return if quests.empty?

    draw_quests_in_progress
  end

  def remove_finished_quest
    draw_quests_in_progress
  end

  private

  def draw_title
    contents.draw_text(0, 0, 300, 32, "Missões Em Progresso: ")
  end

  def draw_quests_in_progress
    contents.clear
    draw_title

    line_height = 20

    quests.each do |q|
      text_color = q.can_finish? ? crisis_color : normal_color
      self.contents.font.color = text_color

      contents.draw_text(15, line_height, 300, 32, "#{q.name}")
      line_height += 20
    end
  end

  def quests
    $game_quests.select { |quest| quest.in_progress }
  end
end