=begin
  * Script RGSS - RPG Maker VX ACE
 
  * Nome: Window Status
  * Descrição: Habilita novos parâmetros na tela de status.
  * Autor: Resque
  * Data: 11/10/2015
=end
 
module WINDOW_STATUS_CONFIG
    PARAM_WIDTH = 55
    PARAM_SPACE = 60

    # Tamanho do ícone 22x25.
    ICON_WIDTH  = 25
    ICON_HEIGHT = 25
end
 
class Window_Status < Window_Selectable
  
  def custom_param_list_1
    [
      { "ATK" => @actor.param(2),  "icon_name" => "fire_icon"},
      { "DEF" => @actor.param(3),  "icon_name" => "fire_icon" },
      { "MAT" => @actor.param(4) },
      { "MDF" => @actor.param(5) },
      { "AGI" => @actor.param(6) },
      { "LUK" => @actor.param(7) },
      { "NEW" => "???" },
      { "NEW" => "???" },
      { "NEW" => "???" }
    ]
  end
 
 
  def custom_param_list_2
    [
      { "Prec"  => (@actor.xparam(0)*100).to_s.split(".").first,  "icon_name" => "fire_icon" },
      { "Evas"  => (@actor.xparam(1)*100).to_s.split(".").first,  "icon_name" => "fire_icon" },
      { "Crít"  => (@actor.xparam(2)*100).to_s.split(".").first },
      { "CAtq" => (@actor.xparam(6)*100).to_s.split(".").first },
      { "Refl"  => (@actor.xparam(5)*100).to_s.split(".").first },
      { "Farm" => (@actor.sparam(3)*100).to_s.split(".").first },
      { "NEW" => "???" },
      { "NEW" => "???" },
      { "NEW" => "???" }
    ]
  end
 
  def custom_param_list_3
    [
      { "Fogo"    => (@actor.element_rate(3)*100).to_s.split(".").first,  "icon_name" => "fire_icon" },
      { "Água"    => (@actor.element_rate(6)*100).to_s.split(".").first,  "icon_name" => "fire_icon" },
      { "Terra"   => (@actor.element_rate(7)*100).to_s.split(".").first,  "font_color" => (Color.new(120,85,70))},
      { "Vento"   => (@actor.element_rate(8)*100).to_s.split(".").first,  "font_color" => (Color.new(0,200,0))},
      { "Luz"     => (@actor.element_rate(9)*100).to_s.split(".").first,  "font_color" => (Color.new(200,200,0))},
      { "Trevas"  => (@actor.element_rate(10)*100).to_s.split(".").first, "font_color" => (Color.new(50,50,50))},
      { "Gelo"    => (@actor.element_rate(4)*100).to_s.split(".").first,  "font_color" => (Color.new(0,150,250))},
      { "Eletr"   => (@actor.element_rate(5)*100).to_s.split(".").first,  "font_color" => (Color.new(150,0,150)) },
      { "Magia"   => (@actor.element_rate(1)*100).to_s.split(".").first,  "font_color" => (Color.new(130,200,180)) }
      
    ]
  end
 
  def custom_param_list_4
    [
      { "Veneno"    => (@actor.state_rate(2)*100).to_s.split(".").first,  "icon_name" => "fire_icon" },
      { "Ceguei"    => (@actor.state_rate(3)*100).to_s.split(".").first,  "icon_name" => "fire_icon" },
      { "Mudez"    => (@actor.state_rate(4)*100).to_s.split(".").first },
      { "Confu"    => (@actor.state_rate(5)*100).to_s.split(".").first },
      { "Sono"    => (@actor.state_rate(6)*100).to_s.split(".").first },
      { "Parali"    => (@actor.state_rate(7)*100).to_s.split(".").first },
      { "Atord"    => (@actor.state_rate(8)*100).to_s.split(".").first },
      { "Congel"    => (@actor.state_rate(28)*100).to_s.split(".").first },
      { "Petrif"    => (@actor.state_rate(29)*100).to_s.split(".").first }
    ]
  end
 
  
 
  def refresh
    contents.clear
    draw_block1   (line_height * 0)
    draw_horz_line(line_height * 1)
    draw_block2   (line_height * 2)
    draw_horz_line(line_height * 6)
    draw_block3   (line_height * 7)
  end
 
  def draw_block3(y)
    print Graphics.width
    x = 0
    custom_param = [custom_param_list_1, custom_param_list_2, custom_param_list_3, custom_param_list_4]
 
    #draw_parameters(x, y)
 
    custom_param.each do |custom_param|
      draw_custom_param(x, y, custom_param)
      x += 136
    end
  end
 
  def draw_custom_param(x, y, param_list)
    line_width_base = WINDOW_STATUS_CONFIG::PARAM_WIDTH
 
    param_list.each_with_index do |param, index|
      # Cor do nome do parâmetro.
      font_color = param["font_color"] ||= system_color
      
      # Nome do parâmetro.
      change_color(font_color)
      draw_text(x + WINDOW_STATUS_CONFIG::ICON_WIDTH, y + line_height * index , line_width_base, line_height, param.keys.first)
      
      # Valor do parâmetro
      change_color(normal_color)
      draw_text(x + line_width_base, y + line_height * index, WINDOW_STATUS_CONFIG::PARAM_SPACE, line_height, param.values.first, 2)
      
      # Imagem do ícone.
     if param["icon_name"] 
        bitmap = Cache.system(param["icon_name"])
        rect = Rect.new(0, 0, WINDOW_STATUS_CONFIG::ICON_WIDTH, WINDOW_STATUS_CONFIG::ICON_HEIGHT)
        contents.blt(x, y + line_height * index, bitmap, rect, true ? 255 : 160)
      end
    end
  end
end