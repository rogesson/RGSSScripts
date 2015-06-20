=begin 
  * Script RGSS(XP) para RPG Maker XP
  
  * Nome: Tile
  * Descrição: Classe responsável por mapear e controlar as tiles do logo.
  * Autor: Resque
  * Data: 28/09/2014
  
  * Features: 
    * Clona uma tile a partir de outra tile  (TODO Incluir eventos).
    * Clona várias tiles a partir de outra tile (TODO Incluir eventos).
    * Move tile (TODO Incluir eventos).

  * Importando Script
    * Insira um novo script acima do Main chamado Tile
    * Copie e cole o Script abaixo dentro do Tile
=end

class Tile
  def initialize(x, y, layer = nil)
    @x = x
    @y = y
    set_tile(x, y, layer)  if layer
    set_event unless layer
  end

  # Copia uma tile para a coordenada x, y.
  def copy_to(x, y)
    $game_map.data[x, y, @layer] = @current_tile
  end

  # Move uma tile para a coordenada x, y.
  def move_to(x, y)
    copy_to(x, y)
    delete

    @current_tile = $game_map.data[x, y, @layer]
  end

  # Deleta tile instanciada.
  def delete
    $game_map.data[@x, @y, @layer] = 0
    @current_tile = 0
  end

  def make_passable
    $tile_manager.make_passable(@current_tile)
  end

  def make_unpassable
    $tile_manager.make_unpassable(@current_tile)
  end

  def event
    @event
  end

  private

  # Redefine a posição da tile instanciada.
  def set_tile(x, y, layer)
    @layer = layer - 1
    @current_tile = $game_map.data[x, y, @layer]
  end

  def events
    $game_map.events.values
  end

  def set_event
    events.each { |evt| @event = evt if evt.x == @x and evt.y == @y }
  end

  # Clona 1 (uma) tile várias vezes a partir do X e Y de outra tile, o parâmetro (times) recebe o número de vezes
  # em que a tile vai ser clonada
=begin Ajustar
  def random_clone(tile_x, tile_y, times)
    times.times do
    # Cria coordenada x e y (randomicamente) da tile a ser substituída.
    next_tile_x  =  rand(@map_x)
    next_tile_y  =  rand(@map_y)
      # Clona a tile se a possicao X e Y passada for válida.
      if valid_tile(next_tile_x, next_tile_y)
        $game_map.data[next_tile_x, next_tile_y, @layer] = $game_map.data[tile_x, tile_y, @layer]
      end
    end
  end
=end

=begin precisa?
  # Verifica se a posição X e Y da tile passada é válida.
  def valid_tile(x, y)
      $game_map.valid?(x, y)              and # Verifica se a tile é válida
      not layer_of_character(x, y)        and # Verifica se o jogador está nessa tile
      $game_map.passable?(x, y, 1)        and # Verifica se Tile 2 é passável
      $game_map.passable?(x, y, 0)        and # Verifica se Tile 1 é passável
      $game_map.passable?(x, y, 2)        and # Verifica se Tile 3 é passável
      $game_map.data[x, y, @layer] ==         
      @tile_to_replace                    and # Verifica se tile randômica é a mesma que foi escolhida para ser substituída
      $game_map.check_event(x, y).class != Fixnum # Verifica se é a tile de um evento
  end

  # Verifica se a tile é a mesma em que o jogador está.
  def layer_of_character(x, y) 
    current_possition = [$game_player.x, $game_player.y]
    current_possition[0] == x and current_possition[1] == y
  end
=end
end