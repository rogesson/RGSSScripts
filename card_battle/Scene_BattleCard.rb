class Scene_CardBattle < Scene_Base

  PHASES = [:draw, :main, :battle]

  def start
    super
    @event_list = { draw: false }
    @current_phase = PHASES[0]
    create_all_windows

    init_battle
  end

  def update
    super
    @window_hand.update if @window_hand.active

    update_input
  end

  def terminate
    super
  end

  def init_battle
    if @current_phase == :draw
      perform_draw
    end
  end

  def perform_draw
    @window_hand.change_state(:draw)
  end

  private

  def update_input
    update_input_window_hand
    update_input_window_battle_field
  end

  def update_input_window_hand
    if @window_hand.current_state == :main && @window_hand.active
      @window_hand.input_next     if Input.trigger?(:RIGHT)
      @window_hand.input_previous if Input.trigger?(:LEFT)

      if Input.trigger?(:UP)
        return if @window_battle_field.selected_card.nil?

        @window_hand.unselect_card
        @window_hand.deactivate
        @window_battle_field.select_card
        @window_battle_field.activate
      end

      if Input.trigger?(:C)
        if @window_hand.selected_card
           @window_hand_action.set_card(@window_hand.selected_card)
        else
          @window_phase.change_phase(@current_phase)
        end
        @window_hand.active = false
      end

      if Input.trigger?(:B)
        @window_phase.change_phase(@current_phase)
        @window_hand.active = false
      end
    end
  end

  def update_input_window_battle_field
    if @window_battle_field.active
      @window_battle_field.input_next     if Input.trigger?(:RIGHT)
      @window_battle_field.input_previous if Input.trigger?(:LEFT)

      if Input.trigger?(:DOWN)
        @window_battle_field.deactivate
        @window_battle_field.unselect_card
        @window_hand.activate
        @window_hand.select_card
      end

      if Input.trigger?(:C)
        @window_card_action.set_card(@window_battle_field.selected_card)
        @window_battle_field.active = false
      end

      if Input.trigger?(:B)
        @window_phase.change_phase(@current_phase)
        @window_battle_field.active = false
      end
    end
  end

  def create_all_windows
    create_message_window
    create_window_battle_field
    create_window_hand_action
    create_window_card_action
    create_window_phase
  end

  def create_message_window
    @window_hand = Window_Hand.new
  end

  def create_window_battle_field
    @window_battle_field = Window_BattleField.new
  end

  def create_window_hand_action
    @window_hand_action = Window_HandAction.new
    @window_hand_action.set_handler(:summon, method(:command_summon))
    @window_hand_action.set_handler(:cancel, method(:command_cancel))
  end

  def create_window_card_action
    @window_card_action = Window_CardAction.new
    @window_card_action.window_battle_field = @window_battle_field
    @window_card_action.set_handler(:attack, method(:command_attack))
    @window_card_action.set_handler(:cancel, method(:command_cancel))
  end

  def create_window_phase
    @window_phase = Window_Phase.new
    @window_phase.window_battle_field = @window_battle_field
    @window_phase.set_handler(:end_turn, method(:command_end_turn))
    @window_phase.set_handler(:cancel, method(:command_cancel))
  end

  def command_end_turn
    @window_phase.close
    @window_battle_field.player = :enemy
    free_field = @window_battle_field.free_field

    free_field.card = Card.new(free_field.sprite.x, free_field.sprite.y)
    free_field.free = false
    free_field.card.slot = free_field

    @window_battle_field.current_player[:fields][0] = free_field

    @window_battle_field.player = :player

    @window_battle_field.can_battle = true if !@window_battle_field.can_battle
    @window_hand.activate
    @window_hand.change_state(:draw)
  end

  def command_summon
    card = @window_hand.selected_card
    card.slot.free = true
    free_field = @window_battle_field.free_field
    card.unselect
    free_field.card = card
    card.sprite.x = free_field.sprite.x
    card.sprite.y = free_field.sprite.y
    card.location = :field
    card.slot     = free_field

    free_field.free = false
    @window_hand_action.close
    @window_hand.remove_from_hand
    @window_battle_field.current_player[:field_index_max] += 1
    @window_battle_field.current_player[:field_index] = @window_battle_field.current_player[:field_index_max] - 1
    @window_battle_field.select_card
    @window_battle_field.activate
  end

  def command_attack
    @window_card_action.close

    battler = @window_battle_field.selected_card
    target  = @window_battle_field.player_list[:enemy][:fields][0].card
    @window_battle_field.battler = battler
    @window_battle_field.battler_target = target
    @window_battle_field.activate
    @window_battle_field.change_state(:battle)
    @window_battle_field.can_battle = false
  end

  def command_cancel
    @window_hand_action.close
    @window_hand_action.deactivate

    @window_card_action.close
    @window_card_action.deactivate

    @window_battle_field.unselect_card
    @window_battle_field.deactivate

    @window_phase.close
    @window_phase.deactivate

    @window_hand.activate
    @window_hand.select_card
  end
end