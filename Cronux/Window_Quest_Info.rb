

class Window_Quest_Info < Window_Selectable
  attr_accessor :quest

  def initialize
    super(380, 60, 240, 410)

    self.contents = Bitmap.new(width - 32, height - 32)
    self.active = false
  end

  def execute
    super
    refresh
  end

  def refresh
    self.contents.clear
    draw_content
  end

  def confirm
    print "confirm"
  end

  # TODO, create go_back method.
  def cancel
    self.contents.clear
    $scene.set_current_window($scene.window_quest_list)
  end

  private

  def draw_content
    draw_description
    draw_reward
  end

  def draw_description
    description = @quest.description.multiline(27)
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
end