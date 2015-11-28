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

class Window_Base < Window
  def initialize(x, y, width, height)
    super()
    @windowskin_name = $game_system.windowskin_name
    
    self.windowskin = RPG::Cache.windowskin(@windowskin_name)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.z = 100
    Font.default_name = "Prototype"
    self.opacity = 190
    #self.back_opacity = 160
  end
end