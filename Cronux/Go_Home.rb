=begin 
  * Script RGSS para RPG Maker XP
  
  * Nome: Voltar para casa
  * Descrição: Faz o herói retornar para casa e descansar.
  * Autor: Resque
  * Data: 25/12/2015

  * Dependências:
    Script Pathfinding do ForeverZer0: http://forum.chaos-project.com/index.php?topic=9784.0

  * Creditos adicionais:
      ForeverZer0 (Script Pathfinding) - http://forum.chaos-project.com/index.php?topic=9784.0

  * Exemplo de uso:

    Adicione o comentário "<portal>" no evento de saída que o herói deve chegar (porta ou portal).
    
   
    Chame o script: go_home
=end

class Interpreter
  def go_home
    find_next_portal
  end

  def find_next_portal
    $game_map.events.values.each do |event|
      event.list.first.parameters.each do |param|
        @next_portal =  { 
                          "x" => event.x,
                          "y" => event.y 
                        } if param == "<portal>"
      end
    end

    go_to_next_portal
  end

  def go_to_next_portal
    $game_map.search_limiter = 5000
    x = @next_portal["x"]
    y = @next_portal["y"]

    range   = 0
    success = Proc.new { nil }
    fail    = Proc.new { nil }

    pathfind(x, y, -1, range, success, fail)
  end 
end
