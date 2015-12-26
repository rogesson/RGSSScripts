class Scene_Map
  def go_to_next_portal
    $game_map.search_limiter = 5000

    find_next_portal
    create_sleep_window

    x = @next_portal["x"]
    y = @next_portal["y"]
    node = Node.new(x, y)
    
  #  success = Proc.new { @sleep_window.dispose }
  #  error   = Proc.new { @sleep_window.dispose }

    Pathfind.new(node, -1)
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
  end

  def create_sleep_window
    Sleep_Window.new
  end
end

class Sleep_Window < Window_Base
  def initialize
    width  = 320
    height = 105 
    x = 320
    y = 240

    x = x - width / 2
    y = y - height / 2

    super(x, y, width, height)

    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.draw_text(4, 0, 406, 40, "ZzZzZZZZzzzZZZZZZ")
    self.contents.draw_text(4, 32, 400, 40, "Você está com muito sono.")
  end
end