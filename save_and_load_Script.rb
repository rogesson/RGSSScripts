=begin 
  *Script RGSS3 para RPG Maker VX Ace
  
  *Nome: Sistema de Save e Load
  *Autor: Resque
  
  *Features: 
    *Exibe o nome do arquivo de Save
    *Exibe nome do personagem que o jogador está controlando
    *Exibe nome do mapa que o jogador se encontra
    *Exibe imagem de fundo
=end

#Classe Window_SaveFile Modificada para Novo Load Game

class Window_SaveFile < Window_Base
  # Alias para refresh
  alias resque_refresh refresh
  def refresh
    resque_refresh
    
    contents.clear
    change_color(normal_color)
    name = Vocab::File + " #{@file_index + 1}"
    draw_text(4, 0, 200, line_height, name)
    @name_width = text_size(name).width
    
    #REMOVE
    draw_party_characters(152, 58)
    #REMOVE
    draw_playtime(0, contents.height - line_height, contents.width - 4, 2)
    
    puts $game_party.members[0].name.to_s
    header = DataManager.load_header(@file_index)
    puts header
  end
end


module DataManager
  class <<self; alias resque_make_save_header make_save_header end
  def self.make_save_header
    self.resque_make_save_header
    header = {}
    header[:characters] = $game_party.characters_for_savefile
    header[:playtime_s] = $game_system.playtime_s
    header[:hero_name]  = $game_party.members[0].name.to_s
    header
  end
end