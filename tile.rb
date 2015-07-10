#############################################################################
#  * Script RGSS(XP) para RPG Maker XP.
#  
#  * Nome: Tile
#  * Descrição: Classe responsável por mapear e controlar as tiles do jogo.
#  * Autor: Resque
#  * Data: 28/09/2014
#  
#  * Features: 
#    * Clona uma tile a partir de outra tile.
#    * Move uma tile tile para uma coordenada especifica.
#    * Clona uma tile para coordenadas randômicas.
#
#  * Importando Script
#    * Insira um novo script acima do Main chamado Tile.
#    * Copie e cole o script abaixo dentro do Tile.
#############################################################################

class Tile
  def initialize(x, y, layer)
    @layer = layer - 1
    set_position(x, y)
  end

  # Copia uma tile para a coordenada x, y.
  def copy_to(x, y)
    $game_map.data[x, y, @layer] = @current_tile
  end

  # Move uma tile para a coordenada x, y.
  def move_to(x, y)
    copy_to(x, y)
    delete

    set_position(x, y)
  end

  # Deleta tile instanciada.
  def delete
    $game_map.data[@x, @y, @layer] = 0
    @current_tile = 0
  end

  # Torna tile passável.
  def make_passable
    $tile_manager.make_passable(@current_tile)
  end

  # Bloqueia passabilidade da tile.
  def block
    $tile_manager.make_unpassable(@current_tile)
  end

  # Clona tile para uma possição randômica. 
  def random_clone(amount = 1)
    amount.times do
      # Cria coordenada x e y (randômicamente) da tile a ser substituída.
      next_tile_x = rand($game_map.width)
      next_tile_y = rand($game_map.height)

      # Clona a tile se a posição randômica for válida.
      if valid_random_tile(next_tile_x, next_tile_y)
        $game_map.data[next_tile_x, next_tile_y, @layer] = @current_tile
      end
    end
  end

  private

  # Redefine a posição da tile instanciada.
  def set_position(x, y)
    @current_tile = $game_map.data[x, y, @layer]
    @x = x
    @y = y
  end

  # Verifica se a tile é a mesma que o herói está.
  def layer_of_character(x, y) 
    current_possition = [$game_player.x, $game_player.y]
    current_possition[0] == x and current_possition[1] == y
  end

  # Verifica se a tile randômica é a tile instanciada.
  def random_tile_is_current_tile?(x, y)
    $game_map.data[x, y, @layer] ==  @current_tile
  end

  # Verifica se é uma tile de evento.
  def event_tile?(x, y)
     $game_map.check_event(x, y).class != Fixnum
  end

  # Verifica se a coordenada randômica é válida.
  def valid_random_tile(x, y)
      $game_map.valid?(x, y)                  and # Verifica se a tile é válida.
      not layer_of_character(x, y)            and # Verifica se o jogador está nessa tile.
      $game_map.passable?(x, y, 1)            and # Verifica se Tile 2 é passável.
      $game_map.passable?(x, y, 0)            and # Verifica se Tile 1 é passável.
      $game_map.passable?(x, y, 2)            and # Verifica se Tile 3 é passável.
      not random_tile_is_current_tile?(x, y)  and # Verifica se tile randômica é a mesma que foi 
                                              # escolhida para ser substituída.
      event_tile?(x, y)                       # Verifica se é a tile de um evento.
  end
end
