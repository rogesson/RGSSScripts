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

    return if @quest.nil?
    active_flag = @quest.in_progress || @quest.completed ? -1 : 0
    self.index = active_flag
    draw_content
  end

  def confirm
    return if @quest.nil?
    return if @quest.in_progress || @quest.completed

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
    draw_requirements
    draw_reward
    draw_options
  end

  def draw_description
    description = @quest.description.multiline(28)
    index_height = 0

    description.split('|').each do |desc|
      contents.draw_text(0, index_height, 212, 32, desc, 0)
      index_height += 20
    end
  end

  def draw_requirements
    @quest.verify_requirements
    draw_item_list("Requerimentos:", 120, @quest.required_items, :required)
  end

  def draw_reward
    draw_item_list("Recompensas:", 230, @quest.rewards, :reward)
  end

  def draw_item_list(title, initial_y, items, item_type)

    contents.draw_text(0, initial_y, 212, 32, title)
    height_index = initial_y + 30

    items.each do |i|
      if i['talk']
        contents.draw_text(0, height_index, 212, 32, i['talk'], 0)
        next
      end

      item = $data_items.compact.find { |data_item|  data_item.id == i['id'] }

      amount = if item_type == :reward
                "#{i['amount']}x"
               else
                "(#{i['acquired'].to_i}/#{i['amount']})"
               end

      bitmap = RPG::Cache.icon(item.icon_name)
      contents.blt(0, height_index, bitmap, Rect.new(0, 0, bitmap.width, bitmap.height))
      contents.draw_text(40, height_index, 212, 32, "#{item.name} #{amount}", 0)

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

    cursor_rect.set(x, y + 350, cursor_width, 32)
  end

  def draw_options
    message = if @quest.in_progress
                'Em Andamento'
              elsif @quest.completed
                'Quest Completa'
              else
                'Iniciar Missão'
              end

    contents.draw_text(50, 350, 212, 32, message, 0)
  end
end