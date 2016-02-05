module QUEST
  # TODO, read from file.
  def self.list
    [
      {
        "name"        => "Ajustes iniciais",
        "description" => "Falar com o capitão para saber qual será o próximo passo.",
        "new"         => true,
        "type"        => "primária",
        "completed"   => false,
        "rewards"     => [
                          { "name" => "Chave da Porta", "amount" => 1}
                         ]
      },
      {
        "name"        => "Movendo os soldados",
        "description" => "Reunir todo batalhão para iniciar a caçada.",
        "new"         => true,
        "type"        => "primária",
        "completed"   => false,
        "rewards"     => [
                          { "name" => "Semente da Vida", "amount" => 1},
                          { "name" => "Pedra Inscrita", "amount" => 2}
                         ]
        
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

  def update
    update_windows
    listen_event
  end

  private

  def setup
    set_current_window(@window_quest_list)
  end

  #TODO, change it to the Scene_Base
  def set_current_window(new_window)
    # Deactive old window
    @current_window.active = false if @current_window
    
    # Set new window and active it.
    @current_window = new_window
    @current_window.active = true
  end

  def quests
    QUEST::list.collect do |quest|
      Quest.new(quest["name"], quest["description"], quest["type"], quest["rewards"])
    end
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
    on_cancel   if Input.trigger?(Input::B)
    on_confirm  if Input.trigger?(Input::C)
  end

  def on_cancel
    case @current_window      
    when Window_Quest_List
      quit
    when Window_Quest_Info
      set_current_window(@window_quest_list)
    end
  end

  def on_confirm
    case @current_window
    when Window_Quest_List
      select_quest
    when Window_Quest_Info
      print 'Quest options'
    end
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

  def select_quest
    set_current_window(@window_quest_info)
    
    @window_quest_info.quest = @window_quest_list.current_quest
    @window_quest_info.draw_informations
  end

  def quit
    $game_system.se_play($data_system.cancel_se)
    $scene = Scene_MenuCustom.new(5)
  end
end