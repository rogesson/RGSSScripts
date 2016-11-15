class Window_Hand < Window_Base
  attr_reader :current_state
  #attr_reader :selected_card

  def initialize
    y = Graphics.height - window_height

    super(0, y, window_width, window_height)
    self.z = 200

    @cards = []

    @slots = []
    @deck  = []
    @hand  = []

    create_slots
    create_deck

    @states =   {
                  draw: { execute:  false },
                  main: { execute:  false }
                }

    @draw_count     = 0
    @hand_index     = 0
    @hand_index_max = 0
  end

  def create_deck
    4.times do
      @cards << Card.new(466, self.y + 15)
    end
  end

  def input_next
    unselect_card
    check_index_max(@hand_index + 1)
    select_card
  end

  def input_previous
    unselect_card
    check_index_max(@hand_index - 1)
    select_card
  end

  def check_index_max(index)
    index = 0                   if index > @hand_index_max - 1
    index = @hand_index_max - 1 if index < 0

    @hand_index = index
  end

  def create_slots
    slot_x = 20
    slot_y = 15 + self.y

    4.times do
      @slots << HandSlot.new(slot_x + self.x, slot_y)

      slot_x += 80
    end
  end

  def draw_phase
    if  @current_state == :draw && @states[@current_state][:execute]
      card = @cards.select { |c| c.location == :deck }.last
      slot = @slots.select { |s| s.free }.first

      if card.sprite.x > slot.sprite.x
        card.sprite.x -= 3
      else
        card.location = :hand
        slot.free     = false
        @hand << card
        @draw_count += 1
        @hand_index_max +=1

        change_state(:main) if @draw_count == 4
      end
    end
  end

  def select_card
    card = @hand[@hand_index]
    return if card.nil?
    card.select
    @selected_card = card
  end

  def unselect_card
    card = @hand[@hand_index]
    return if card.nil?
    card.unselect
  end

  def remove_from_hand
    card = @hand[@hand_index]
    @hand.delete_at(@hand_index)
    @hand_index = 0
    @hand_index_max -=1
    @selected_card = nil
  end

  def update
    super

    return if @current_state.nil?
    draw_phase
    main_phase
  end

  def main_phase
    if @current_state == :main && @states[@current_state][:execute]
      select_card
      @states[@current_state][:execute] = false if @current_state
    end
  end

  def change_state(state)
    @states[@current_state][:execute] = false if @current_state
    @current_state = state
    @states[@current_state][:execute] = true
  end

  private

  def window_width
    Graphics.width
  end

  def window_height
    fitting_height(visible_line_number)
  end

  def visible_line_number
    return 4
  end
end