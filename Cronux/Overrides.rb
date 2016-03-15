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
    $scene = Scene_MenuCustom.new(7)
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
    $scene = Scene_MenuCustom.new(7)
  end

  def write_save_data(file)
    # Criar desenho dos Heróis para salvar
    characters = []
    for i in 0...$game_party.actors.size
      actor = $game_party.actors[i]
      characters.push([actor.character_name, actor.character_hue])
    end
    # Gravar desenho dos Heróis para salvar
    Marshal.dump(characters, file)
    # Gravar contador de Tempo de Jogo
    Marshal.dump(Graphics.frame_count, file)
    # Acrescentar 1 em contador de saves
    $game_system.save_count += 1
    # Salvar número da Magia
    # Um número aleatório será selecionado cada vez que você salvar
    $game_system.magic_number = $data_system.magic_number
    # Gravar cada tipo de objeto do jogo
    Marshal.dump($game_system, file)
    Marshal.dump($game_switches, file)
    Marshal.dump($game_variables, file)
    Marshal.dump($game_self_switches, file)
    Marshal.dump($game_screen, file)
    Marshal.dump($game_actors, file)
    Marshal.dump($game_party, file)
    Marshal.dump($game_troop, file)
    Marshal.dump($game_map, file)
    Marshal.dump($game_player, file)
    Marshal.dump($game_quests, file)
  end
end


class Scene_Load < Scene_File
  def read_save_data(file)
    # Ler dados dos Heróis para desenhar o arquivo de save
    characters = Marshal.load(file)
    # Ler o contador de Frames para obter o tempo de jogo
    Graphics.frame_count = Marshal.load(file)
    # Ler cada tipo de objeto do jogo
    $game_system        = Marshal.load(file)
    $game_switches      = Marshal.load(file)
    $game_variables     = Marshal.load(file)
    $game_self_switches = Marshal.load(file)
    $game_screen        = Marshal.load(file)
    $game_actors        = Marshal.load(file)
    $game_party         = Marshal.load(file)
    $game_troop         = Marshal.load(file)
    $game_map           = Marshal.load(file)
    $game_player        = Marshal.load(file)
    $game_quests        = Marshal.load(file)
    # Se o número mágico for diferente ao de quando foi salvo
    # (Se uma edição foi adicionada por um editor)
    if $game_system.magic_number != $data_system.magic_number
      # Carregar mapa
      $game_map.setup($game_map.map_id)
      $game_player.center($game_player.x, $game_player.y)
    end
    # Atualizar membros do grupo
    $game_party.refresh
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
    $scene = Scene_MenuCustom.new(8)
  end

  def update
    # Atualizar janela de comandos
    @command_window.update
    # Se o botão B for pressionado
    if Input.trigger?(Input::B)
      # Reproduzir SE de cancelamento
      $game_system.se_play($data_system.cancel_se)
      # Alternar para a tela de Menu
      $scene = Scene_MenuCustom.new(8)
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
  end

  def execute
    $scene.set_current_window(self)
  end
end

class String
  def multiline(line_limit)
    words = self.split(' ')
    line = ''
    lines = []
    new_line = true

    for word in words
      if line.size + word.size < line_limit
        line << "#{word} "
      else
        new_line = true
        line = "|#{word} "
      end

      lines << line if new_line
      new_line = false
    end

    lines.join
  end
end

class Scene_Title
  def command_new_game
    # Reproduzir SE de OK
    $game_system.se_play($data_system.decision_se)
    # Parar BGM
    Audio.bgm_stop
    # Aqui o contador de frames é resetado para que se conte o Tempo de Jogo
    Graphics.frame_count = 0
    # Criar cada tipo de objetos do jogo
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_screen        = Game_Screen.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
    $game_quests        = quests_list
    # Configurar Grupo Inicial
    $game_party.setup_starting_members
    # Configurar posição inicial no mapa
    $game_map.setup($data_system.start_map_id)
    # Aqui o Jogador é movido até a posição inical configurada
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    # Atualizar Jogador
    $game_player.refresh
    # Rodar, de acordo com o mapa, a BGM e a BGS
    $game_map.autoplay
    # Atualizar mapa (executar processos paralelos)
    $game_map.update
    # Mudar para a tela do mapa
    $scene = Scene_Map.new
  end

  def quests_list
    QUEST_INFO::list.collect do |quest|
                Quest.new(
                          quest['name'],
                          quest['description'],
                          quest['new_quest'],
                          quest['type'],
                          quest['completed'],
                          quest['open'],
                          quest['rewards']
                        )
              end
  end
end