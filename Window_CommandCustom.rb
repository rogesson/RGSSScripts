#  * Script RGSS para RPG Maker XP
#  
#  * Nome: Custom SceneMenu
#  * Descrição: Script responsável por exibir as opções do menu.
#  * Autor: Resque
#  * Data: 08/08/2015

class Window_CommandCustom < Window_Selectable
  #--------------------------------------------------------------------------
  # Inicialização dos Objetos
  #
  #     width    : largura da janela
  #     commands : ordem dos comandos
  #--------------------------------------------------------------------------

  def initialize(width, commands)
    super(0, 0, width, 480)
    @item_max = commands.size
    @commands = commands
    @commands_y = [0, 70 , 180, 329, 420, 500]
    self.contents = Bitmap.new(width - 32, @item_max * 32)
    refresh
    self.index = 0
  end

  def refresh
    self.contents.clear
    
    
    @item_max.times do |i|
      draw_item(i, @commands_y[i], normal_color)
    end
    #for i in 0...@item_max
    #  draw_item(i, normal_color)
    #end
  end

  def draw_item(index, x, color)
    self.contents.font.color = color
    rect = Rect.new(x, 32, self.contents.width - 8, 32)
    #rect = Rect.new(4, 32 * index, self.contents.width - 8, 32)
    self.contents.fill_rect(rect, Color.new(0, 0, 0, 0))
    self.contents.draw_text(rect, @commands[index])
  end

  def disable_item(index)
    draw_item(index, disabled_color)
  end
end