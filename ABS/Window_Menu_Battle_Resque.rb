class Window_Menu_Battle_Resque < Window_Command

  def initialize
    @window_width = 300
    super(0, 0)
  end

  def refresh
    super
  end

  def update
    super
  end

  def window_width
    return 160
  end

  def make_command_list
    add_command("Item", :new_game)
    add_command("Skill", :new_game)
    add_command("Status", :shutdown)
  end

end