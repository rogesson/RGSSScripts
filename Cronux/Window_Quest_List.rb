class Window_Quest_List < Window_Selectable
  def initialize(quests)
    super(20, 60, 350, 410)

    @quests       = quests
    @item_max     = quests.size
    self.contents = Bitmap.new(width - 32, row_max * 32)

    self.index = 0
    @column_max = 1
  end

  def execute
    super
    
    @quests.each_with_index do |quest, index|
      draw_quest(quest, index)
    end
  end

  def confirm
    $scene.window_quest_info.quest = current_quest
    $scene.window_quest_info.execute
  end

  def cancel
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_MenuCustom.new(5)
  end

  def draw_quest(quest, index)
    x = 4
    y = index * 32

    rect = Rect.new(x, y, self.width - 32, 32)
    
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    #bitmap = RPG::Cache.icon(item.icon_name)
    opacity = self.contents.font.color == normal_color ? 255 : 128
    
    #self.contents.blt(x, y + 4, bitmap, Rect.new(0, 0, 24, 24), opacity)
    self.contents.draw_text(x + 28, y, 212, 32, quest.name, 0)
    #self.contents.draw_text(x + 240, y, 88, 32, "bla", 2)
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


    self.cursor_rect.set(x, y, cursor_width, 32)
  end

  def current_quest
    description = @quests[self.index]
  end
end