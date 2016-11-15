class Window_Phase < Window_Command
  def initialize
    super(0, 0)
    self.z = 300
    update_placement

    self.openness = 0
    deactivate
  end

  def change_phase(current_phase)
    @current_phase = current_phase
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
    return if @current_phase.nil?

    add_command('Battle Phase', :attack)
    add_command('End Turn',  :defense)
    add_command('Cancel',   :cancel)

    @current_phase = nil
  end

  def window_height
    150
  end
end