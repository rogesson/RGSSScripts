class Window_CommandCustom < Window_Selectable
  def initialize(commands)
    super(20, -4, 190, 641)
    @item_max = commands.size
    @commands = commands
    self.contents = Bitmap.new(width - 32, @item_max * 80)
    refresh
    self.index = 0
  end

  def refresh
    self.contents.clear
    for i in 0...@item_max
      draw_item(i, normal_color)
    end
  end

  def draw_item(index, color)
    y = 60 * index + 60

    command = @commands[index]
    
    self.contents.font.color = color
    rect = Rect.new(40, y, self.contents.width - 8, 60)
    draw_item_image(y, command[:sprite_name])

    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, command[:text])
  end

  def disable_item(index)
    draw_item(index, disabled_color)
  end

  def draw_item_image(y, sprite_name)
    bitmap = RPG::Cache.icon(sprite_name)
    self.contents.blt(5, y + 10, bitmap, Rect.new(0, 0, 24, 24))
  end
end

class Window_Selectable < Window_Base
  def update_cursor_rect
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
    y = @index / @column_max * 60 - self.oy
    y += 74

    self.cursor_rect.set(x, y, cursor_width, 32)
  end
end