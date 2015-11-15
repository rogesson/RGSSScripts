#  * Script RGSS para RPG Maker XP
#  
#  * Nome: Custom SceneMenu
#  * Descrição: Script responsável por exibir o menu.
#  * Autor: Resque
#  * Data: 08/08/2015


module OPTIONS_CONFIG
  ITEM = {
    :name => :item, 
    :text => 'Item',
    :sprite_name => 'item_1'
  }

  SKILL    = {
    :name => :skill,
    :text => 'Habilidade',
    :sprite_name => 'skill_1'
  }

  EQUIP   = {
    :name => :equip,
    :text => 'Equipamento',
    :sprite_name => 'equip_1'
  }

  STATUS   = {
    :name => :status,
    :text => 'Status',
    :sprite_name => 'status_1'
  }

  SAVE    = {
    :name => :save,
    :text => 'Salvar',
    :sprite_name => 'save_1'
  }

  QUIT    = {
    :name => :quit,
    :text => 'Sair',
    :sprite_name => 'exit_1'
  } 
end

class Scene_MenuCustom
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end

  def main
    commands = [ 
      OPTIONS_CONFIG::ITEM,
      OPTIONS_CONFIG::SKILL,
      OPTIONS_CONFIG::EQUIP,
      OPTIONS_CONFIG::STATUS,
      OPTIONS_CONFIG::SAVE,
      OPTIONS_CONFIG::QUIT
    ]
    
  
    @command_window = Window_CommandCustom.new(commands)

    @status_window = Window_MenuStatusCustom.new
    
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
    @command_window.dispose
  end


  #--------------------------------------------------------------------------
  # Atualização do Frame
  #--------------------------------------------------------------------------
  def update
    if @command_window.active
      @command_window.update
      #update_command
      return
    end
  end
  
  #--------------------------------------------------------------------------
  # Atualização do Frame (Quando a janela de Comandos estiver Ativa)
  #--------------------------------------------------------------------------
  
  def update_command
    if Input.trigger?(Input::LEFT)
      @command_window.update_command(:previous)
    end
    
    if Input.trigger?(Input::RIGHT)
      @command_window.update_command(:next)
    end

    if Input.trigger?(Input::C)
     
      case @command_window.option_name
      when :faction
        play_se_ok
      when :item
        play_se_ok
        @command_window.disable
      when :skill
        play_se_ok
        #$scene = Scene_Skill.new(@status_window.index)
      when :equip
        play_se_ok
        #$scene = Scene_Equip.new(@status_window.index)
      when :save
        play_se_ok
        #$scene = Scene_Status.new(@status_window.index)
      end
      return
    end

    if Input.trigger?(Input::B)
      play_cancel_se
      $scene = Scene_Map.new
      return
    end
  end

  def play_se_ok
    $game_system.se_play($data_system.decision_se)
  end

  def play_cancel_se
    $game_system.se_play($data_system.cancel_se)
  end

  def create_all_windows
  end
end

# Override da chamada do menu.
class Scene_Map
  def call_menu
    # Limpar flag de chamada de Menu
    $game_temp.menu_calling = false
    # Se a flag de Beep estiver definida
    if $game_temp.menu_beep
      # Reproduzir SE de OK
      $game_system.se_play($data_system.decision_se)
      # Limpar flag de Beep
      $game_temp.menu_beep = false
    end
    # Alinhar a posição do Jogador
    $game_player.straighten
    # Alternar para a tela de Menu
    $scene = Scene_MenuCustom.new
    #$scene = Scene_Menu.new
  end
end
