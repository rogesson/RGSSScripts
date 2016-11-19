class Window_CardAction < Window_Command

  attr_accessor :window_battle_field, :card

  def initialize
    super(0, 0)
    self.z = 300
    update_placement

    self.openness = 0
    deactivate
  end

  def set_card(card)
    @card = card
    refresh
    select(0)
    activate
    open
  end

  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height * 1.6 - height) / 2
  end

  def make_command_list
    return if @card.nil?

    add_command('Attack',   :attack)  if @window_battle_field.can_battle
    add_command('Cancel',   :cancel)

    @card = nil
  end

  def window_height
    100
  end
end