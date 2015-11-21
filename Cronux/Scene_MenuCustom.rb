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

    #@status_window = Window_MenuStatusCustom.new
    
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
      update_command
      return
    end

    if @status_window.active
      @status_window.update
      update_status
      return
    end
  end
  
  #--------------------------------------------------------------------------
  # Atualização do Frame (Quando a janela de Comandos estiver Ativa)
  #--------------------------------------------------------------------------
  
  def update_command
    if Input.trigger?(Input::C)
      case @command_window.option_name
      when :item
        play_se_ok
        $scene = Scene_Item.new
      when :skill
        play_se_ok
        @command_window.active = false
        @status_window = Window_MenuStatusCustom.new(:skill)
      when :equip
        play_se_ok
        @command_window.active = false
        @status_window = Window_MenuStatusCustom.new(:equip)
      when :status
        play_se_ok
        @command_window.active = false
        @status_window = Window_MenuStatusCustom.new(:status)
      when :save
        play_se_ok
        $scene = Scene_Save.new
      when :quit
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_End.new
      end
      return
    end

    if Input.trigger?(Input::B)
      play_cancel_se
      $scene = Scene_Map.new
      return
    end
  end

  def update_status
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Torna a janela de comandos ativa
      @command_window.active = true
      @status_window.close
      @status_window.index = -1
      return
    end
    # Se o botão C for pressionado
    if Input.trigger?(Input::C)
      # Ramificação por posição do cursor na janela de comandos
      @status_window.close

      case @status_window.option_name
      when :skill  # Habilidades
        # Se o limite de ação deste Herói for de 2 ou mais
        if $game_party.actors[@status_window.index].restriction >= 2
          # Reproduzir SE de erro
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Alternar para a tela de Habilidades
        $scene = Scene_Skill.new(@status_window.index)
      when :equip  # Equipamento
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Alternar para a tela de Equipamento
        $scene = Scene_Equip.new(@status_window.index)
      when :status  # Status
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Alternar para a tela de Status
        $scene = Scene_Status.new(@status_window.index)
      end
      return
    end
  end

  def play_se_ok
    $game_system.se_play($data_system.decision_se)
  end

  def play_cancel_se
    $game_system.se_play($data_system.cancel_se)
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
