=begin 
  * Script RGSS(XP) para RPG Maker XP
  
  * Nome: Tile Manager
  * Descrição: Classe responsável pelo gerenciamento das tiles do jogo.
  * Autor: Resque
  * Data: 06/06/2014
  
  * Features: 
    * Torna uma tile passável/bloqueada

  * Importando Script
    * Insira um novo script acima do Main chamado Tile_Manager
    * Copie e cole o Script abaixo dentro do Tile_Manager
=end

# 
class Tile_Manager
  def passable_tiles
    [396]
  end

  def make_passable(tile_id)
  end

  def make_unpassable(tile_id) 
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
    $tile_manager       = Tile_Manager.new

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

end


class Game_Map
  def passable?(x, y, d, self_event = nil)
    # Se as coordenadas dadas forem fora do mapa
    unless valid?(x, y)
      # Impasável
      return false
    end

    # Mudar direção (0,2,4,6,8,10) para bloqueado (0,1,2,4,8,0)
    bit = (1 << (d / 2 - 1)) & 0x0f

    # Loop em todos os Eventos
    for event in events.values
      # Se os Tiles forem outros que automático e as coordenas coincidirem
      if event.tile_id >= 0 and event != self_event and
         event.x == x and event.y == y and not event.through
        # Se for bloqueado
        if @passages[event.tile_id] & bit != 0
          # Impassável
          return false
        # se for um bloqueado em todas as direções
        elsif @passages[event.tile_id] & 0x0f == 0x0f
          # Impassável
          return false
        # Se as prioridades forem outras que 0
        elsif @priorities[event.tile_id] == 0
          # Passável
          return true
        end
      end
    end
    # Loop procura a ordem do layer de topo
    for i in [2, 1, 0]
      # Selecionar o ID do Tile
      tile_id = data[x, y, i]
      # Se houver falha na aquisição do Tile
      if tile_id == nil
        # Impassável
        return false
      # Se foi mapeada como passado pelo Tile_Manager
      elsif $tile_manager.passable_tiles.include? tile_id
        return true
      # Se for 
      elsif @passages[tile_id] & bit != 0
        return false
      # Se for bloqueado em todas as direções
      elsif @passages[tile_id] & 0x0f == 0x0f
        # Impassável
        return false
      # Se as prioridades forem outras que 0
      elsif @priorities[tile_id] == 0
        # Passável
        return true
      end
    end
    # Passável
    return true
  end

end