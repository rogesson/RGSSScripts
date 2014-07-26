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
  # Alias para refresh
  alias resque_refresh refresh
  def refresh
    resque_refresh
     
    contents.clear
    change_color(normal_color)
    #name = Vocab::File + " #{@file_index + 1}"
    name = " #{@file_index + 1} -"
    #draw_text(4, 0, 200, line_height, name)
    draw_text(150, 0, 200, line_height, name)
    
    @name_width = text_size(name).width
    
    ##### Escreve o nome do herói
    #draw_hero_name(0, contents.height - line_height, contents.width - 4, 2)
    draw_hero_name(4, 0, 250, 2)
    
    draw_map_name(4, 0, 394, 2)

    if $game_map.map_id != 0
      puts $game_map.display_name 
    end
  end
end


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


#######################
#Escreve nome do herói
#######################
def draw_hero_name(x, y, width, align)
    header = DataManager.load_header(@file_index)
    return unless header
    draw_text(x, y, width, line_height, "#{header[:hero_name]}/", 2)
end

#######################
#Escreve nome do mapa
#######################
def draw_map_name(x, y, width, align)
    header = DataManager.load_header(@file_index)
    return unless header
    draw_text(x, y, width, line_height, header[:map_name], 2)
end