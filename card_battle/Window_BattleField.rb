class Window_BattleField < Window_Base
  attr_reader :player_fields, :selected_card
  attr_accessor :player_field_index, :player_field_index_max

  def initialize
    super(20, 15, window_width, window_height)
    self.z = 200
    deactivate
    @player_fields = []
    @enemy_fields  = []


    @player_field_index     = 0
    @player_field_index_max = 0

    create_fields
  end

  def free_field
    @player_fields.select { |s| s.free }.first
  end

  def update
    return if !active
    update_selected
  end

  def update_selected
    card_selected = @selected_card
    card_selected.sprite.opacity < 250 ? card_selected.sprite.opacity += 4 : card_selected.sprite.opacity = 70
  end

  def input_next
    unselect_card
    check_index_max(@player_field_index + 1)
    select_card
  end

  def input_previous
    unselect_card
    check_index_max(@player_field_index - 1)
    select_card
  end

  def unselect_card
    card = @player_fields[@player_field_index].card
    return if card.nil?
    card.unselect
  end

  def select_card
    card = @player_fields[@player_field_index].card
    return if card.nil?
    card.select
    @selected_card = card
  end

  def check_index_max(index)
    index = 0  if index > @player_field_index_max - 1
    index = @player_field_index_max - 1 if index < 0

    @player_field_index = index
  end

  private

  def create_slot(player)
    slot_x = 20

    if player == :player
      slot_y = 160
    else
      slot_y = 40
    end

    6.times do
      fields = player == :player ? @player_fields : @enemy_fields

      fields << FieldSlot.new(slot_x + self.x, slot_y)

      slot_x += 80
    end
  end

  def create_fields
    create_slot(:player)
    create_slot(:enemy)
  end

  def window_width
    Graphics.width - 40
  end

  def window_height
    fitting_height(visible_line_number)
  end

  def visible_line_number
    10
  end
end