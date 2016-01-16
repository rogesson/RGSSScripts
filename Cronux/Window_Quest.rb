class Window_Quest < Window_Base
  def initialize
    super(0, 0, 640, 480)

    self.contents = Bitmap.new(width - 32, height - 32)

    draw_title
  end

  def draw_title
    self.contents.draw_text(32, 0, 212, 32, 'Missões')
  end
end