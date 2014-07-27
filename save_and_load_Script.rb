=begin 
  *Script RGSS3 para RPG Maker VX Ace
  
  *Nome: Sistema de Save e Load
  
  *Features: 
    *Exibe o nome do arquivo de Save
    *Exibe nome do personagem que o jogador está controlando
    *Exibe nome do mapa que o jogador se encontra
    *Exibe imagem de fundo
=end

class Window_SaveFile < Window_Base
  
  #--------------------------------------------------------------------------
  # * Override do Initialize
  #--------------------------------------------------------------------------
  def initialize(height, index)
      super(0, index * height, Graphics.width, height)
      @file_index = index
      refresh
      @selected = false
      #self.back_opacity = 1
      self.opacity = 1
  end
  
  #--------------------------------------------------------------------------
  # * Alias para refresh
  #--------------------------------------------------------------------------
  alias resque_refresh refresh
  def refresh
    resque_refresh
     
    contents.clear
    change_color(normal_color)
    name = " #{@file_index + 1}"
    
    @name_width = text_size(name).width
  
    #--------------------------------------------------------------------------
    # * Escreve informações do herói
    #--------------------------------------------------------------------------
    draw_save_info(150, 0, 180, 2)

    if $game_map.map_id != 0
      #puts $game_map.display_name 
    end
  end
  
  #--------------------------------------------------------------------------
  # * Override do update_cursor
  #--------------------------------------------------------------------------
  def update_cursor      
      if @selected
        #cursor_rect.set(0, 0, @name_width + 8, line_height)
        cursor_rect.set(0, 0, @name_width + 478, line_height)
      else
        cursor_rect.empty
      end
  end
end


#--------------------------------------------------------------------------
# * Salva dados de nome do herói e nome do mapa no arquivo de save
#--------------------------------------------------------------------------
module DataManager
  class <<self; alias resque_make_save_header make_save_header end
  def self.make_save_header
    header = {}
    header[:characters] = $game_party.characters_for_savefile
    header[:playtime_s] = $game_system.playtime_s
    header[:hero_name]  = $game_party.members[0].name.to_s
    header[:map_name]   = $game_map.display_name
    header
  end
end


#--------------------------------------------------------------------------
# * Escreve informações do herói
#--------------------------------------------------------------------------
def draw_save_info(x, y, width, align)
    header = DataManager.load_header(@file_index)
    return unless header
    draw_text(x, y, width, line_height, "#{@file_index + 1} - #{header[:hero_name]}/#{header[:map_name]}", 2)
end

#--------------------------------------------------------------------------
# * Escreve o nome do mapa
#--------------------------------------------------------------------------
def draw_map_name(x, y, width, align)
    header = DataManager.load_header(@file_index)
    return unless header
    draw_text(x, y, width, line_height, header[:map_name], 2)
end

#--------------------------------------------------------------------------
# * Override da classe Scene_File
#--------------------------------------------------------------------------  
class Scene_File < Scene_MenuBase
  
  #--------------------------------------------------------------------------
  # * Alias para start
  #-------------------------------------------------------------------------- 
  alias resque_start start
  def start
    resque_start
    super
    create_background
    create_help_window
    create_savefile_viewport
    create_savefile_windows
    init_selection
  end
  
  #--------------------------------------------------------------------------
  # * Alias para create_help_window
  #--------------------------------------------------------------------------
  alias resque_create_help_window create_help_window
  def create_help_window
    resque_create_help_window
    @help_window = Window_Help.new(1)
    @help_window.set_text(help_window_text)
    @help_window.visible = false
  end
    
  
#--------------------------------------------------------------------------
# * Criacao do metodo create_background
#-------------------------------------------------------------------------- 
  def create_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = Cache.system("YourImage")
    # YourImage.png must be exist in Graphics/system
  end
end  
  