class Window_Quest_Info < Window_Base
  def initialize
    super(380, 60, 240, 410)

    self.contents = Bitmap.new(width - 32, height - 32)
    self.active = false

    @need_update = false
  end

  def update
    super

    self.contents.clear unless self.active
  end

  def draw_information(quest_info)
    self.active = true
    @need_update = true

    self.contents.draw_text(0, 0, 212, 32, quest_info, 0)
  end
end