class Window_Menu_Resque < Window_HorzCommand

  attr_accessor :enabled

  def initialize(x, y, width)
    @window_width = width
    super(x, y)
    
    #self.opacity = 0
    @enabled      = false
    @need_refresh = true
  end

  def window_width
    @window_width
  end

  def enable
    self.index = 0
    self.show
    @enabled = true
  end

  def disable
    self.hide
    @enabled = false
  end

  def refresh
    super
    return if not @enabled
    return if not @need_refresh
    
    self.contents.clear
    @need_refresh = false
  end

  def make_command_list
    add_command("Item", :new_game)
    add_command("Skill", :new_game)
    add_command("Status", :shutdown)
  end

  def col_max
    return 3
  end
end