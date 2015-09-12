#  * Script RGSS para RPG Maker XP
#  
#  * Nome: Custom SceneMenu
#  * Descrição: Script responsável por exibir as opções do menu.
#  * Autor: Resque
#  * Data: 08/08/2015

class Window_CommandCustom < Window_Base
  #--------------------------------------------------------------------------
  # Inicialização dos Objetos
  #
  #     width    : largura da janela
  #     commands : ordem dos comandos
  #--------------------------------------------------------------------------
  attr_accessor :index

  def initialize(width, commands)
    super(0, 0, width, 480)
    @item_max = commands.size
    @commands = commands
    @commands_y = [0, 70 , 180, 329, 420, 500]

    #self.contents = Bitmap.new(width - 32, 350)
    self.contents = Bitmap.new(width - 32, 350)
    self.contents.font.name = "Snap ITC"
    self.contents.font.size = 24
    
    refresh
    @index = 0
    self.opacity = 0

    create_background
    create_window_option
  end
=begin
  def refresh
    self.contents.clear
    @item_max.times do |i|
      #Color.new(192, 192, 192, 255)
      draw_item(i, @commands_y[i], normal_color)
    end
  end
=end
  def refresh
    self.contents.clear
  end

  def draw_item(index, x, color)
    self.contents.font.color = color
    rect = Rect.new(x, 300,  self.contents.width - 8, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index])
  end

  def disable_item(index)
    draw_item(index, disabled_color)
  end

  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = RPG::Cache.picture("menu_background")
    @background_sprite.opacity = 100
  end

  def create_window_option
    window_option = Window_Base.new(0, 300, 640, 100)
    window_option.opacity = 75
    
    update_menu
  end

  def font_grey_color
    return Color.new(192, 192, 192, 255)
  end

  def update_menu
    @item_max.times do |i|
      draw_item(i, @commands_y[i], normal_color)
    end
  end
end

