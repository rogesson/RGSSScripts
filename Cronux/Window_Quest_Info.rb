class Window_Quest_Info < Window_Selectable
  attr_accessor :quest

  def initialize
    super(380, 60, 240, 410)

    self.contents = Bitmap.new(width - 32, height - 32)
    self.active = false

    self.index = -1
    @column_max = 1
    @item_max = 1
  end

  def execute
    super
    active_flag = @quest.in_progress ? -1 : 0
    self.index = active_flag
    draw_content
  end

  def confirm
    @quest.start_quest
    contents.clear
    @index = -1

    draw_content
  end

  # TODO, create go_back method.
  def cancel
    contents.clear
    $scene.set_current_window($scene.window_quest_list)
    self.index = -1
  end

  private

  def draw_content
    draw_description
    draw_reward
    draw_options
  end

  def draw_description
    description = @quest.description.multiline(30)
    index_height = 0

    description.split('|').each do |desc|
      contents.draw_text(0, index_height, 212, 32, desc, 0)
      index_height += 20
    end
  end

  def draw_reward
    contents.draw_text(0, 160, 212, 32, "Recompensas:")
    height_index = 200

    @quest.rewards.each do |reward|
      item = $data_items.compact.find { |data_item|  data_item.name == reward["name"] }

      bitmap = RPG::Cache.icon(item.icon_name)
      contents.blt(0, height_index, bitmap, Rect.new(0, 0, bitmap.width, bitmap.height))
      contents.draw_text(40, height_index, 212, 32, "#{item.name} x1", 0)

      height_index += 30
    end
  end

  def update_cursor_rect
    super

    if @index < 0
      self.cursor_rect.empty
      return
    end

    row = @index / @column_max
    if row < self.top_row
      self.top_row = row
    end

    if row > self.top_row + (self.page_row_max - 1)
      self.top_row = row - (self.page_row_max - 1)
    end

    cursor_width = self.width / @column_max - 32
    x = @index % @column_max * (cursor_width + 32)
    y = @index / @column_max * 32 - self.oy

    cursor_rect.set(x, y + 300, cursor_width, 32)
  end

  def draw_options
    return if @quest.in_progress
    draw_accept_buttom
  end

  def draw_accept_buttom
    contents.draw_text(4, 300, 212, 32, 'Iniciar Missão', 0)
  end
end