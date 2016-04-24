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

    contents.clear
    draw_title
    draw_quests_in_progress
  end

  private

  def draw_title
    contents.draw_text(0, 0, 300, 32, "Missões Em Progresso: ")
  end

  def draw_quests_in_progress
    line_height = 20

    quests.each do |q|
      completed = q.can_finish? ? " - OK" : nil
      #completed = nil
      contents.draw_text(15, line_height, 300, 32, "- #{q.name}#{completed}")
      line_height += 20
    end
  end

  def quests
    $game_quests.select { |quest| quest.in_progress }
  end
end