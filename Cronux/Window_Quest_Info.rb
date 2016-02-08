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
    description = multiline(@quest.description, 25)
    index_height = 0

    description.split("|").each do |desc|
      self.contents.draw_text(0, index_height, 212, 32, desc, 0)
      index_height += 20
    end
  end

  def draw_reward
    self.contents.draw_text(0, 160, 212, 32, "Recompensas:")
    height_index = 200

    @quest.rewards.each do |reward|
      item = $data_items.compact.find { |data_item|  data_item.name == reward["name"] }
     
      bitmap = RPG::Cache.icon(item.icon_name)
      self.contents.blt(0, height_index, bitmap, Rect.new(0, 0, bitmap.width, bitmap.height))
      self.contents.draw_text(40, height_index, 212, 32, "#{item.name} x1", 0)

      height_index += 30
    end
  end

  def multiline(text, line_width)
    words = text.split(" ")
    line = ''
    lines = []
    new_line = true

    for word in words
      if line.size + word.size < line_width
        line << "#{word} "
      else
        new_line = true
        line = "|#{word} "
      end

      lines << line if new_line
      new_line = false
    end

    lines.join
  end
end