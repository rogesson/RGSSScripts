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

  def initialize(width, commands)
    super(0, 0, width, 480)
    self.opacity = 0

    create_background
    
    @index = 0
    @options = []
    option_x = 0

    4.times do
      @options << new_option(option_x, 300)
      option_x += 150
    end
  
    select_option
  end

  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = RPG::Cache.picture("menu_background_3")
  end

  def new_option(x, y)
    option_sprite = Sprite.new
    option_sprite.bitmap = Bitmap.new("Graphics/Pictures/start")

    option_sprite.x = x
    option_sprite.y = y

    option_sprite
  end

  def update_command(option)
    unselect_option
    option == :next ? increment_index : decrement_index
    select_option
  end

  def increment_index
    if @index < @options.length - 1
      @index += 1
    else 
      @index = 0
    end
  end

   def decrement_index
    if @index < 1
      @index = @options.length - 1
    else
      @index -= 1
    end
  end

  def select_option
    current_option = @options[@index]
    current_option.y = 280
  end

  def unselect_option
    current_option = @options[@index]
    current_option.y = 300
  end
end