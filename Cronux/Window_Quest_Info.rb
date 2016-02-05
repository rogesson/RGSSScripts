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
    draw_reward
  end

  private
  
  def draw_description
    description = word_wrap(@quest.description, 10)
    self.contents.draw_text(0, 0, 212, 32, description, 0)
  end

  def draw_reward
    self.contents.draw_text(0, 80, 212, 32, "Recompensas:")
    height_index = 120

    @quest.rewards.each do |reward|
      item = $data_items.compact.find { |data_item|  data_item.name == reward["name"] }
     
      bitmap = RPG::Cache.icon(item.icon_name)
      self.contents.blt(0, height_index, bitmap, Rect.new(0, 0, bitmap.width, bitmap.height))
      self.contents.draw_text(40, height_index, 212, 32, "#{item.name} x1", 0)

      height_index += 30
    end
  end
end