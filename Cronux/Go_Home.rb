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
    
    Existem três motivos para o herói voltar para casa:
      * Sono  = :sleep
      * Fome  = :hunger
      * Danos = :damage

    Chame o script: go_home(motivo)

    Ex: go_home(:sleep)
        go_home(:hunger)
        go_home(:damage)
=end

class Interpreter
  def go_home(reason)
    @reason = reason
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

    create_sleep_window
    go_to_next_portal
  end

  def create_sleep_window
    @sleep_window = Sleep_Window.new(@reason)
  end

  def go_to_next_portal
    $game_map.search_limiter = 5000
    x = @next_portal["x"]
    y = @next_portal["y"]

    range   = 0
    success = Proc.new { @sleep_window.dispose }
    fail    = Proc.new { print 'Rota nao encontrada' }

    pathfind(x, y, -1, range, success, fail)
  end 
end

class Sleep_Window < Window_Base
  def initialize(reason)
    @reason = reason

    width  = 320
    height = 105 
    x = 320
    y = 240

    x = x - width / 2
    y = y - height / 2

    super(x, y, width, height)

    self.contents = Bitmap.new(width - 32, height - 32)
    setup
  end

  def setup
    find_reason
    show_message
  end

  def find_reason
    case @reason
    when :sleep
      @message = "Estou com muito sono ZzZzZ"
    when :hunger
      @message = "Estou com muita fome."
    when :die
      @message = "Estou muito ferido"
    else
      @message = ""
    end
  end

  def show_message
    self.contents.draw_text(4, 0, 406, 40, "Preciso ir para casa agora!")
    self.contents.draw_text(4, 32, 400, 40, @message)
  end
end