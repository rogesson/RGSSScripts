class Window_BattleField < Window_Base
  attr_reader :player_fields, :selected_card
  attr_writer :player

  attr_accessor :player_list, :can_battle
  attr_accessor :battler, :battler_target, :current_state

  @@battle_hits = 7

  def initialize
    super(20, 15, window_width, window_height)
    self.z = 200

    @can_battle = false

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

    @states =   {
                  battle: { execute:  false }
                }

    @bg = Sprite.new
    @bg.bitmap = Cache.system("bg")

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
    update_battle

    enemy_turn
  end


  def update_battle
    if @current_state == :battle && @states[@current_state][:execute]

      if @battler.sprite.y != @battler_target.slot.sprite.y
        @battler.sprite.y < @battler_target.slot.sprite.y ? @battler.sprite.y  += 5 :  @battler.sprite.y  -= 5
      else
         @battler.sprite.angle = rand(200)
         @battler_target.sprite.y -= rand(2)
         @battler_target.sprite.x -= rand(2)

        if  @battler.sprite.x != @battler_target.sprite.x
          @battler.sprite.x < @battler_target.sprite.x ? @battler.sprite.x  += 5 :  @battler.sprite.x  -= 5
        else
          @battler.sprite.y = @battler.slot.sprite.y
          @battler.sprite.x = @battler.slot.sprite.x
          @@battle_hits -= 1

          if @@battle_hits == 0
            @battler.sprite.y = @battler.slot.sprite.y
            @battler.sprite.x = @battler.slot.sprite.x
            @battler.sprite.angle = 0

            @battler_target.slot.free = true
            @battler_target.sprite.dispose
            @battler_target.sprite = nil
            @@battle_hits = 7
            player_list[:enemy][:fields][0].card = nil
            @states[@current_state][:execute] = false
          end
        end
      end
    end

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