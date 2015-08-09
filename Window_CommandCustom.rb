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
    self.contents = Bitmap.new(width - 32, 350)
    self.contents.font.color = Color.new(192, 192, 192, 255)
    self.contents.font.name = "Snap ITC"
    self.contents.font.size = 21
    
    
    #Font.name = "Neverwinter"
    #self.bitmap.font.size = 32
    #self.contents = Bitmap.new(width - 32, @item_max * 32)
    refresh
    @index = 0
    self.opacity = 1
    create_background
  end

  def refresh
    self.contents.clear
    
    @item_max.times do |i|
      draw_item(i, @commands_y[i], normal_color)
    end
  end

  def draw_item(index, x, color)
    bitmap = RPG::Cache.picture("menu_equip")
    self.contents.blt(x, 300, bitmap, Rect.new(0, 0, bitmap.width, bitmap.height))
  end

  def disable_item(index)
    draw_item(index, disabled_color)
  end

  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = RPG::Cache.picture("menu_background")
  end
end
