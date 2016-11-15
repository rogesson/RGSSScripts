class Window_CardAction < Window_Command
  def initialize
    super(0, 0)
    self.z = 300
    update_placement

    self.openness = 0
    deactivate
  end

  def set_card(card)
    @card = card
    open
    activate
    select(0)
  end

  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height * 1.6 - height) / 2
  end

  def make_command_list
    add_command('Attack', :attack)
    add_command('Defense', :defense)
    add_command('Cancel', :cancel)
  end
end