module QUEST
  def self.list
    [
      {
        "name"        => "Ajustes iniciais",
        "description" => "Falar com o capitão para saber qual será o próximo passo.",
        "new"         => true,
        "type"        => "primária",
        "completed"   => false
      },
      {
        "name"        => "Movendo os soldados",
        "description" => "Reunir todo batalhão para iniciar a caçada.",
        "new"         => true,
        "type"        => "primária",
        "completed"   => false
      }
    ]
  end 
end

class Scene_Quest
  def main
    create_windows
    
    setup

    Graphics.transition

    loop do
      Graphics.update
      Input.update
      update

      if $scene != self
        break
      end
    end

    Graphics.freeze

    dispose_windows
  end

  def setup
    @window_quest_list.active
  end

  def update
    update_windows
    listen_event
  end

  def quests
    QUEST::list
  end

  def create_windows
    @window_quest      = Window_Quest.new
    @window_quest_list = Window_Quest_List.new(quests)
    @window_quest_info = Window_Quest_Info.new
  end

  def update_windows
    @window_quest.update
    @window_quest_list.update
    @window_quest_info.update
  end

  def dispose_windows
    @window_quest.dispose
    @window_quest_list.dispose
    @window_quest_info.dispose
  end

  def listen_event
    on_return       if Input.trigger?(Input::B)
    on_select_quest if Input.trigger?(Input::C)
  end

  def on_return
    if @window_quest_list.active
      $game_system.se_play($data_system.cancel_se)
      $scene = Scene_MenuCustom.new(5)
    else
      @window_quest_info.active = false
      @window_quest_list.active = true
    end
  end

  def on_select_quest
    @window_quest_info.draw_information("O inicio de um novo mundo.")

    @window_quest_list.active = false
  end
end