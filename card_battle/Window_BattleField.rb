class Window_BattleField < Window_Base
  attr_reader :player_fields, :selected_card
  attr_writer :player

  def initialize
    super(20, 15, window_width, window_height)
    self.z = 200


    @player       = :player

    @player_list  =  {
                        player: {
                                  fields:          [],
                                  field_index:     0,
                                  field_index_max: 0
                        },
                        enemy: {
                                  fields:          [],
                                  field_index:     0,
                                  field_index_max: 0
                        }
                      }

    deactivate
    create_fields
  end

  def current_player
    @player_list[@player]
  end

  def free_field
    current_player[:fields].select { |s| s.free }.first
  end

  def update
    return if !active
    update_selected

    enemy_turn
  end

  def enemy_turn
    if @current_state == :enemy_turn && @states[@current_state][:execute]
      p 'enemy_turn'
    end
  end

  def change_state(state)
    @states[@current_state][:execute] = false if @current_state
    @current_state = state
    @states[@current_state][:execute] = true
  end

  def update_selected
    return if @selected_card.nil?
    card_selected = @selected_card
    card_selected.sprite.opacity < 250 ? card_selected.sprite.opacity += 4 : card_selected.sprite.opacity = 70
  end

  def input_next
    unselect_card
    check_index_max(current_player[:field_index] + 1)
    select_card
  end

  def input_previous
    unselect_card
    check_index_max(current_player[:field_index] - 1)
    select_card
  end

  def unselect_card

    return if card_at_slot.nil?
    card_at_slot.unselect
  end

  def select_card
    return if card_at_slot.nil?
    card_at_slot.select
    @selected_card = card_at_slot
  end

  def card_at_slot
    current_player[:fields][current_player[:field_index]].card
  end

  def check_index_max(index)
    index = 0  if index > current_player[:field_index_max] - 1
    index = current_player[:field_index_max] - 1 if index < 0

    current_player[:field_index] = index
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
      @player_list[player][:fields] << FieldSlot.new(slot_x + self.x, slot_y)

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