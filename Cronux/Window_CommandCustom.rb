class Window_CommandCustom < Window_Selectable

  OPTION_HEIGHT = 43

  def initialize(commands)
    super(20, -4, 190, 641)

    @item_max = commands.size
    @commands = commands
    self.contents = Bitmap.new(width - 32, @item_max * 80)
    refresh
    
    self.index = 0

    create_images
  end

  def refresh
    self.contents.clear
    for i in 0...@item_max
      draw_item(i, normal_color)
    end
  end

  def dispose
    super

    @background_sprite.dispose
    @eagle_icon_sprite.dispose
  end

  def option_name
    @commands[self.index][:name]
  end



  def draw_item(index, color)
    y = OPTION_HEIGHT * index + 60

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
    bitmap = RPG::Cache.picture(sprite_name)
    self.contents.blt(5, y + 18, bitmap, Rect.new(0, 0, 24, 24))
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
    y = @index / @column_max * OPTION_HEIGHT - self.oy
    y += 74

    self.cursor_rect.set(x, y, cursor_width, 32)
  end

  private

  def create_images
    create_eagle_icon
    create_background
  end

  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = RPG::Cache.picture("background")
  end

  def create_eagle_icon
    @eagle_icon_sprite = Sprite.new
    @eagle_icon_sprite.bitmap = RPG::Cache.picture("Icon_silver_eagle")

    @eagle_icon_sprite.x = 55
    @eagle_icon_sprite.y = -7
    @eagle_icon_sprite.z = 101
    @eagle_icon_sprite.opacity = 150
  end
end