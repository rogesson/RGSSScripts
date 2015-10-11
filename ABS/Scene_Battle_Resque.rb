class Scene_Battle_Resque < Scene_MenuBase
  def start
    super
    create_background
    create_menu_window
  end

  def create_menu_window
    @menu_battle_resque = Window_Menu_Battle_Resque.new
    @menu_battle_resque.set_handler(:item, method(:command_menu))
    @menu_battle_resque.set_handler(:skill, method(:command_menu))
    @menu_battle_resque.set_handler(:status, method(:command_menu))
    @menu_battle_resque.set_handler(:cancel,    method(:return_scene))
  end

  def command_menu
    p 'command_menu selected'
    @menu_battle_resque.active = true
    @menu_battle_resque.set_handler(:ok,     method(:on_menu_ok))
    @menu_battle_resque.set_handler(:cancel, method(:on_menu_cancel))
    #SceneManager.call(Scene_item)
  end

  def on_menu_ok
    case @menu_battle_resque.current_symbol
    when :item
      p ':item'
      #SceneManager.call(Scene_Equip)
    when :skill
      p ':skill'
      #SceneManager.call(Scene_Skill)
    when :status
      p ':status'
      #SceneManager.call(Scene_Status)
    end
  end

  def on_menu_cancel
    p 'cancel'
    @menu_battle_resque.unselect
    @menu_battle_resque.activate
  end
end