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

    self.index = 0
    draw_content
  end

  def confirm
    @quest.start_quest
    
    force_update do
      draw_content
    end
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

    description.split('|').each do |d|
      self.contents.draw_text(0, index_height, 212, 32, d, 0)
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

    self.cursor_rect.set(x, y + 300, cursor_width, 32)
  end

  def draw_options
    x = 4
    y = 300
    
    @quest.new_quest ? draw_accept_buttom(x, y) : draw_finish_buttom(x, y)

    contents.font.color = normal_color
  end

  def draw_accept_buttom(x, y)
    contents.font.color = normal_color
    contents.draw_text(x, y, 212, 32, 'Aceitar Missão', 0)
  end

  def draw_finish_buttom(x, y)
    contents.font.color = disabled_color
    contents.draw_text(x, y, 212, 32, 'Concluir Missão', 0)
  end
end