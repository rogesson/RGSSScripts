# Scene_Map Override
class Scene_Map < Scene_Base

  alias menu_window_start     start
  alias menu_window_update    update
  alias menu_window_terminate terminate

  def start
    menu_window_start
    @menu_window = Window_Menu_Resque.new(0, Graphics.height - 50, Graphics.width)
    @menu_window.disable
  end

  def update
    @menu_window.refresh
    menu_window_update
  end

  def call_menu
    create_menu_window if @menu_calling
  end

  def create_menu_window
    Sound.play_ok
    if @menu_window.enabled
      @menu_window.disable
      @menu_calling = false
    end 

    if not @menu_window.enabled and @menu_calling
      @menu_window.enable
      @menu_calling = false
    end
  end
end