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
    @command_window.index = @menu_index
    
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

class Scene_Status
  def update
    # Caso o botão B seja pressionado
    if Input.trigger?(Input::B)
      # É tocada a música SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Mudar para a tela do Menu
      $scene = Scene_MenuCustom.new(3)
      return
    end
    # Caso o botão R seja pressionado
    if Input.trigger?(Input::R)
      # Reproduzir Se de seleção
      $game_system.se_play($data_system.cursor_se)
      # Para o próximo Herói
      @actor_index += 1
      @actor_index %= $game_party.actors.size
      # Mudar para uma tela de Status diferente
      $scene = Scene_Status.new(@actor_index)
      return
    end
    # Caso o botão L seja pressionado
    if Input.trigger?(Input::L)
      # Reproduzir SE de seleção
      $game_system.se_play($data_system.cursor_se)
      # Para o Herói anterior
      @actor_index += $game_party.actors.size - 1
      @actor_index %= $game_party.actors.size
      # Mudar para uma tela de Status diferente
      $scene = Scene_Status.new(@actor_index)
      return
    end
  end
end

class Scene_Skill

  def update_skill
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Alternar para a tela de Menu
      $scene = Scene_MenuCustom.new(1)
      return
    end
    # Se o botão C for pressionado
    if Input.trigger?(Input::C)
      # Selecionar dados escolhidos na janela de Habilidades
      @skill = @skill_window.skill
      # Aqui é verificado se é possível utilizar a Habilidade
      if @skill == nil or not @actor.skill_can_use?(@skill.id)
        # Reproduzir SE de erro
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Reproduzir SE de OK
      $game_system.se_play($data_system.decision_se)
      # Se o efeito da Habilidade for um aliado
      if @skill.scope >= 3
        # Ativar janela alvo
        @skill_window.active = false
        @target_window.x = (@skill_window.index + 1) % 2 * 304
        @target_window.visible = true
        @target_window.active = true
        # Definir se o alcance é um aliado ou todo o grupo
        if @skill.scope == 4 || @skill.scope == 6
          @target_window.index = -1
        elsif @skill.scope == 7
          @target_window.index = @actor_index - 10
        else
          @target_window.index = 0
        end
      # Se o efeito for outro senão para um aliado
      else
        # Se o ID do evento comum for válido
        if @skill.common_event_id > 0
          # Chamar evento comum da reserva
          $game_temp.common_event_id = @skill.common_event_id
          # Reproduzir SE da Habilidade
          $game_system.se_play(@skill.menu_se)
          # Descontar MP
          @actor.sp -= @skill.sp_cost
          # Recriar cada conteúdo das janelas
          @status_window.refresh
          @skill_window.refresh
          @target_window.refresh
          # Alternar para a tela do Mapa
          $scene = Scene_Map.new
          return
        end
      end
      return
    end
    # Se o botão R for pressionado
    if Input.trigger?(Input::R)
      # Reproduzir SE de cursor
      $game_system.se_play($data_system.cursor_se)
      # O comando leva ao próximo Herói
      @actor_index += 1
      @actor_index %= $game_party.actors.size
      # Alternar para uma tela de Habilidades diferente
      $scene = Scene_Skill.new(@actor_index)
      return
    end
    # Se o botão L for pressionado
    if Input.trigger?(Input::L)
      # Reproduzir SE de cursor
      $game_system.se_play($data_system.cursor_se)
      # O comando leva ao Herói anterior
      @actor_index += $game_party.actors.size - 1
      @actor_index %= $game_party.actors.size
      # Alternar para uma tela de Habilidades diferente
      $scene = Scene_Skill.new(@actor_index)
      return
    end
  end
end

class Scene_Save < Scene_File
  def on_decision(filename)
    # Reproduzir Se de Save
    $game_system.se_play($data_system.save_se)
    # Graavar
    file = File.open(filename, "wb")
    write_save_data(file)
    file.close
    # Caso tenha sido chamdo por um evento...
    if $game_temp.save_calling
      # Limpar flag de chamado de save
      $game_temp.save_calling = false
      # Mudar para a tela do Mapa
      $scene = Scene_Map.new
      return
    end
    # Mudar para a tela do Menu
    $scene = Scene_MenuCustom.new(4)
  end

  def on_cancel
    # Reproduzir SE de cancelamento
    $game_system.se_play($data_system.cancel_se)
    # Caso tenha sido chamdo por um evento...
    if $game_temp.save_calling
      # Limpar flag de chamado de save
      $game_temp.save_calling = false
      # Mudar para a tela do Mapa
      $scene = Scene_Map.new
      return
    end
    # Mudar para a tela do Menu
    $scene = Scene_MenuCustom.new(4)
  end
end

class Scene_Item
  def update_item
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Alternar para a tela de Menu
      $scene = Scene_MenuCustom.new(0)
      return
    end
    # Se o botão C for pressionado
    if Input.trigger?(Input::C)
      # Selecionar os dados escolhidos na janela de Itens
      @item = @item_window.item
      # Se não for um Item usável
      unless @item.is_a?(RPG::Item)
        # Reproduzir SE de erro
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Se não puder ser usado
      unless $game_party.item_can_use?(@item.id)
        # Reproduzir SE de erro
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Reproduzir SE de OK
      $game_system.se_play($data_system.decision_se)
      # Se o alcance do Item for um aliado
      if @item.scope >= 3
        # Ativar a janela alvo
        @item_window.active = false
        @target_window.x = (@item_window.index + 1) % 2 * 304
        @target_window.visible = true
        @target_window.active = true
        # Definir a posição do cursor no alvo (aliado / todo grupo)
        if @item.scope == 4 || @item.scope == 6
          @target_window.index = -1
        else
          @target_window.index = 0
        end
      # Se o alcance for outro senão um aliado
      else
        # Se o ID do evento comum for inválido
        if @item.common_event_id > 0
          # Chamar evento comum da reserva
          $game_temp.common_event_id = @item.common_event_id
          # Reproduzir SE do Item
          $game_system.se_play(@item.menu_se)
          # Se for consumível
          if @item.consumable
            # Diminui 1 Item da quantidade total
            $game_party.lose_item(@item.id, 1)
            # Desenhar o Item
            @item_window.draw_item(@item_window.index)
          end
          # Alternar para a tela do Mapa
          $scene = Scene_Map.new
          return
        end
      end
      return
    end
  end
end

class Scene_Equip
  def update_right
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Alternar para a tela de Menu
      $scene = Scene_MenuCustom.new(2)
      return
    end
    # Se o botão C for pressionado
    if Input.trigger?(Input::C)
      # Se o equipamento for fixo
      if @actor.equip_fix?(@right_window.index)
        # Reproduzir SE de erro
        $game_system.se_play($data_system.buzzer_se)
        return
      end
      # Reproduzir SE de OK
      $game_system.se_play($data_system.decision_se)
      # Ativar janela de Itens
      @right_window.active = false
      @item_window.active = true
      @item_window.index = 0
      return
    end
    # Se o botão R for pressionado
    if Input.trigger?(Input::R)
      # Reproduzir SE de cursor
      $game_system.se_play($data_system.cursor_se)
      # O cursor se move para o próximo Herói
      @actor_index += 1
      @actor_index %= $game_party.actors.size
      # Alternar para uma tela de equipamento diferente
      $scene = Scene_Equip.new(@actor_index, @right_window.index)
      return
    end
    # Se o botão L for precionado
    if Input.trigger?(Input::L)
      # Reproduzir SE de cursor
      $game_system.se_play($data_system.cursor_se)
      # O cursor se move para o Herói anterior
      @actor_index += $game_party.actors.size - 1
      @actor_index %= $game_party.actors.size
      # Alternar para uma tela de equipamento diferente
      $scene = Scene_Equip.new(@actor_index, @right_window.index)
      return
    end
  end
end

class Scene_End
  def command_cancel
    # Reproduzir SE de OK
    $game_system.se_play($data_system.decision_se)
    # Alternar para a tela do Menu
    $scene = Scene_MenuCustom.new(5)
  end

  def update
    # Atualizar janela de comandos
    @command_window.update
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Alternar para a tela de Menu
      $scene = Scene_MenuCustom.new(5)
      return
    end
    # Se o botão C for pressionado
    if Input.trigger?(Input::C)
      # Ramificação por posição na janela de comandos
      case @command_window.index
      when 0  # Ir à tela de título
        command_to_title
      when 1  # Sair
        command_shutdown
      when 2  # Cancelar
        command_cancel
      end
      return
    end
  end
end