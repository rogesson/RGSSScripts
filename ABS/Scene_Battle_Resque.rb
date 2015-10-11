class Scene_Battle_Resque < Scene_MenuBase
  def start
    super
    create_background
    create_menu_window
  end

  def create_menu_window
    @menu_battle_resque = Window_Menu_Battle_Resque.new
    @menu_battle_resque.set_handler(:item, method(:item))
    @menu_battle_resque.set_handler(:skill, method(:skill))
    @menu_battle_resque.set_handler(:status, method(:status))
  end

  def item
    p 'item selected'
    @menu_battle_resque.active = true
  end

  def skill
    p 'skill selected'
    @menu_battle_resque.active = true
  end

  def status
    p 'status selected'
    @menu_battle_resque.active = true
  end
end