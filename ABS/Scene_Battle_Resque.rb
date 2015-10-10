class Scene_Battle_Resque 
  def initialize
    @active = true
    initialize_battle
  end

  def battle_started?
    @active == true
  end

  def update
    @menu_window.update
  end

  private

  def initialize_battle
    print 'Battle Started'
    create_all_windows
  end

  def finish_battle
    @active = false
  end

  def create_all_windows
    create_message_window
    create_menu_window
  end

  def create_message_window
    
  end

  def create_menu_window
    @menu_window = Window_Menu_Battle_Resque.new
  end
end