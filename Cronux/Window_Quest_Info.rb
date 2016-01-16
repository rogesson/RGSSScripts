class Window_Quest_Info < Window_Base
  attr_accessor :quest

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

  def draw_informations
    self.active = true
    draw_description
  end

  private 
  
  def draw_description
    description = word_wrap(@quest.description, 10)
    self.contents.draw_text(0, 0, 212, 32, description, 0)
  end
end