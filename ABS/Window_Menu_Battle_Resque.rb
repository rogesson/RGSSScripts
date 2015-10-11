class Window_Menu_Battle_Resque < Window_Command

  def initialize
    @window_width = 300
    super(0, 0)
    self.index = 0
  end

  def make_command_list
    add_command("Item", :item)
    add_command("Skill", :skill)
    add_command("Status", :status)
  end
end