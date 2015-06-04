=begin 
  * Script RGSS(XP) para RPG Maker XP
  
  * Nome: Clone Tile
  * Descrição: Clona uma Tile
  * Autor: Resque
  * Data: 28/09/2014
  
  * Features: 
    * Clona uma tile a partir de outra tile
    * Clona várias tiles a partir de outra tile

  * Importando Script
    * Insira um novo script acima do Main chamado Clone_Tile
    * Copie e cole o Script abaixo dentro do Clone_Tile
=end

class Clone_Tile
  def initialize(x, y, layer)
    @map_x = $game_map.width
    @map_y = $game_map.height
    @layer = layer - 1
    @x = x
    @y = y
    @tile_to_replace = $game_map.data[y, y, @layer]
  end

  # Clona 1 (uma) tile várias vezes a partir do X e Y de outra tile, o parâmetro (times) recebe o número de vezes
  # em que a tile vai ser clonada
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

  # Copia uma tile para a coordenada x, y.
  def copy_to(x, y)
    $game_map.data[x, y, @layer] = $game_map.data[@x, @x, @layer]
  end

  # Move umatile para a coordenada x, y.
  def move(x, y)
    print  $game_map.data[@x, @x, @layer].methods
    #$game_map.data[x, y, @layer] = $game_map.data[@x, @x, @layer]
  end

  private

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
end