#  * Script RGSS para RPG Maker XP
#  
#  * Nome: Custom SceneMenu
#  * Descrição: Script responsável por exibir o menu.
#  * Autor: Resque
#  * Data: 08/08/2015

module SCENE_MENU_CONFIGURATION
  ITEM        = 'Item'
  SKILL       = 'Habilidade'
  EQUIP       = 'Equipamento'
  STATUS      = 'Status'
  SAVE_QUIT   = 'Salvar/Sair'
end

# Classe respnsável por exibir o menu.
class Scene_MenuCustom
  def initialize(menu_index = 0)
    #menu_index : posição inicial do cursor de comando
    @menu_index = menu_index
  end

  def main
    # Criar janela de comando
    command_item      = SCENE_MENU_CONFIGURATION::ITEM
    command_skill     = SCENE_MENU_CONFIGURATION::SKILL
    command_equip     = SCENE_MENU_CONFIGURATION::EQUIP
    command_status    = SCENE_MENU_CONFIGURATION::STATUS
    command_save_quit = SCENE_MENU_CONFIGURATION::SAVE_QUIT

    command_list = [
                    command_item, 
                    command_skill,
                    command_equip,
                    command_status,
                    command_save_quit
                  ]

    @command_window = Window_CommandCustom.new(640, command_list)

    @command_window.index = @menu_index
    
    #VERIFICAR SE PERMANECE
    # Se o número de membros do Grupo de Heróis for 0
    if $game_party.actors.size == 0
      # Desabilar as janelas de Item, Habilidades, Equipamento e Status
      @command_window.disable_item(0)
      @command_window.disable_item(1)
      @command_window.disable_item(2)
      @command_window.disable_item(3)
    end

    #VERIFICAR SE PERMANECE
    # Se Salvar for Proibido
    if $game_system.save_disabled
      # Desabilitar Salvar
      @command_window.disable_item(4)
    end

    # REMOVENDO JANELA DE TEMPO
    # Criar janela de Tempo de Jogo
    #@playtime_window = Window_PlayTime.new
    #@playtime_window.x = 0
    #@playtime_window.y = 224
    
    # REMOVENDO JANELA DE PASSOS
    # Criar janela de Número Passos
    #@steps_window = Window_Steps.new
    #@steps_window.x = 0
    #@steps_window.y = 320
    
    #REMOVENDO JANELA DE DINHEIRO
    # Criar janela de Dinheiro
    #@gold_window = Window_Gold.new
    #@gold_window.x = 0
    #@gold_window.y = 416
    
    # REMOVENDO JANELA DE STATUS
    # Criar janela de Status
    #@status_window = Window_MenuStatus.new
    #@status_window.x = 160
    #@status_window.y = 0
    # Executar transição
    Graphics.transition
    # Loop principal
    loop do
      # Atualizar a tela de jogo
      Graphics.update
      # Atualizar a entrada de informações
      Input.update
      # Atualizar Frame
      update
      # Abortar loop se a tela for alterada
      if $scene != self
        break
      end
    end
    # Preparar para transiçõa
    Graphics.freeze
    # Exibição das janelas
    @command_window.dispose
    #@playtime_window.dispose
    #@steps_window.dispose
    #@gold_window.dispose
    #@status_window.dispose
  end


  #--------------------------------------------------------------------------
  # Atualização do Frame
  #--------------------------------------------------------------------------
  
  def update
    # Atualizar janelas
    @command_window.update
    #@playtime_window.update
    #@steps_window.update
    #@gold_window.update
    #@status_window.update
    # Se a janela de comandos estiver ativo: chamar update_command
    if @command_window.active
      update_command
      return
    end
    # Se a janela de Status estiver ativa: call update_status
    #if @status_window.active
    #  update_status
    #  return
    #end
  end
  
  #--------------------------------------------------------------------------
  # Atualização do Frame (Quando a janela de Comandos estiver Ativa)
  #--------------------------------------------------------------------------
  
  def update_command
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Alternar para a tela do mapa
      $scene = Scene_Map.new
      return
    end
    # Se o botão C for pressionado
    if Input.trigger?(Input::C)
      # Se o comando for outro senão Salvar, Fim de Jogo e o número de Heróis no
      # Grupo for 0
      if $game_party.actors.size == 0 and @command_window.index < 4
        # Reproduzir SE de erro
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Ramificação por posição do cursor na janela de comandos
      case @command_window.index
      when 0  # Itens
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Alternar para a tela de Itens
        $scene = Scene_Item.new
      when 1  # Habilidades
        # Play decision SE
        $game_system.se_play($data_system.decision_se)
        # Ativar o status da janela
        #@command_window.active = false
        #@status_window.active = true
        #@status_window.index = 0
      when 2  # Equipamentos
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Ativar o status da janela
        #@command_window.active = false
        #@status_window.active = true
        #@status_window.index = 0
      when 3  # Status
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Ativar o status da janela
        #@command_window.active = false
        #@status_window.active = true
        #@status_window.index = 0
      when 4  # Salvar
        # Se Salvar for proibido
        if $game_system.save_disabled
          # Reproduzir SE de erro
          $game_system.se_play($data_system.buzzer_se)
          return
        end
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Alternar para a tela de save
        $scene = Scene_Save.new
      when 5  # Fim de Jogo
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Alternar para a tela de Fim de Jogo
        $scene = Scene_End.new
      end
      return
    end
  end
  
  #--------------------------------------------------------------------------
  # Atualização do Frame (Quando o status da Janela estiver Ativo)
  #--------------------------------------------------------------------------
  
  def update_status
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Torna a janela de comandos ativa
      @command_window.active = true
      #@status_window.active = false
      #@status_window.index = -1
      return
    end
    # Se o botão C for pressionado
    if Input.trigger?(Input::C)
      # Ramificação por posição do cursor na janela de comandos
      case @command_window.index
      when 1  # Habilidades
        # Se o limite de ação deste Herói for de 2 ou mais
        #if $game_party.actors[@status_window.index].restriction >= 2
          # Reproduzir SE de erro
        #  $game_system.se_play($data_system.buzzer_se)
        #  return
        #end
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Alternar para a tela de Habilidades
        #$scene = Scene_Skill.new(@status_window.index)
      when 2  # Equipamento
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Alternar para a tela de Equipamento
        #$scene = Scene_Equip.new(@status_window.index)
      when 3  # Status
        # Reproduzir SE de OK
        $game_system.se_play($data_system.decision_se)
        # Alternar para a tela de Status
        #$scene = Scene_Status.new(@status_window.index)
      end
      return
    end
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
