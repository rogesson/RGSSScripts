#  * Script RGSS para RPG Maker XP
#  
#  * Nome: Custom SceneMenu
#  * Descrição: Script responsável por exibir o menu.
#  * Autor: Resque
#  * Data: 08/08/2015

module GLOBAL_CONFIG

  module OPTIONS_CONFIG
    FACTION = {
        :sprite_name => 'faccao',
        :x => 10,  
        :y => 300,
    }

    ITEM    = {
      :sprite_name => 'item',
      :x => 166,  
      :y => 300,
    }


    SKILL   = {
      :sprite_name => 'habilidade',
      :x => 276,  
      :y => 300,
    }

    EQUIP   = {
      :sprite_name => 'equipamento',
      :x => 370,  
      :y => 300,
    }

    SAVE    = {
      :sprite_name => 'salvar',
      :x => 490,  
      :y => 300,
    }
  end
end

class Scene_MenuCustom
  def initialize(menu_index = 0)
    @menu_index = menu_index
  end

  def main
    command_item      = GLOBAL_CONFIG::OPTIONS_CONFIG::FACTION
    command_skill     = GLOBAL_CONFIG::OPTIONS_CONFIG::ITEM
    command_equip     = GLOBAL_CONFIG::OPTIONS_CONFIG::SKILL
    command_status    = GLOBAL_CONFIG::OPTIONS_CONFIG::EQUIP
    command_save_quit = GLOBAL_CONFIG::OPTIONS_CONFIG::SAVE

    command_list = [
                    command_item, 
                    command_skill,
                    command_equip,
                    command_status,
                    command_save_quit
                  ]

    @command_window = Window_CommandCustom.new(640, command_list)

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
      update_command
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

    if Input.trigger?(Input::B)
      $scene = nil
    end
  end
  
  #--------------------------------------------------------------------------
  # Atualização do Frame (Quando o status da Janela estiver Ativo)
  #--------------------------------------------------------------------------
  
  def update_status
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
