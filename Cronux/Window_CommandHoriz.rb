#  * Script RGSS para RPG Maker XP
#  
#  * Nome: Custom SceneMenu
#  * Descrição: Script responsável por exibir as opções do menu.
#  * Autor: Resque
#  * Data: 08/08/2015

module IMAGES_CONFIG
  BACKGROUND = {
    :background_sprite_name => 'menu_background_3'
  }

  LOGO = {
    :sprite_name => 'logo',
    :x => 120
  }

  CURSOR = {
    :sprite_name => 'cursor'
  }
end

class Window_CommandHoriz < Window_Base
  #--------------------------------------------------------------------------
  # Inicialização dos Objetos
  #
  #     width    : largura da janela
  #     commands : ordem dos comandos
  #--------------------------------------------------------------------------

  attr_accessor :option_name

  def initialize(width, commands)
    super(0, 0, width, 480)
    @index        = 0
    self.opacity  = 0

    @commands = commands
    
    create_background
    create_cursor
    create_logo
    create_options

    @cursor_max_opacity = true
  end

  def update_command(option)
    unselect_option
    option == :next ? increment_index : decrement_index
    select_option
    update_cursor_position
  end

  def option_name
    @option_name[@index]
  end

  def update
    super
    if @cursor_max_opacity
      @cursor.opacity -= 5
      @cursor_max_opacity = false if @cursor.opacity == 70
    else
      @cursor.opacity += 5
      @cursor_max_opacity = true if @cursor.opacity == 255
    end
  end

  def disable
    self.active = false
    @cursor.opacity = 0
  end

  private

  def create_options
    @options = []
    commands =  @commands

    commands.each{|c| @options << add_option(c[:x], c[:y], c[:sprite_name], c[:name]) }

    select_option
    update_cursor_position
  end

  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = RPG::Cache.picture(IMAGES_CONFIG::BACKGROUND[:background_sprite_name])
  end

  def add_option(x, y, picture_name, name)
    @option_name = @option_name || []
    @option_name << name

    option_sprite = Sprite.new
    option_sprite.bitmap = Bitmap.new("Graphics/Pictures/#{picture_name}")

    option_sprite.x = x
    option_sprite.y = y
    option_sprite.opacity = 170

    option_sprite
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
    current_option.opacity = 250
  end

  def unselect_option
    current_option.opacity = 170
  end

  def current_option
    current_option = @options[@index]
  end

  def create_cursor
    @cursor = Sprite.new
    @cursor.bitmap = Bitmap.new("Graphics/Pictures/#{IMAGES_CONFIG::CURSOR[:sprite_name]}")
    @cursor.opacity = 180
  end

  def update_cursor_position
    @cursor.x = current_option.x + (current_option.bitmap.width / 2 - 22)
    @cursor.y = current_option.y + 70
  end

  def create_logo
    @logo = Sprite.new
    @logo.bitmap = Bitmap.new("Graphics/Pictures/#{IMAGES_CONFIG::LOGO[:sprite_name]}")
    @logo.x = IMAGES_CONFIG::LOGO[:x]
    @logo.opacity = 90
  end
end