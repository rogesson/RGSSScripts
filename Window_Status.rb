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

    # Largura do ícone
    ICON_WIDTH  = 25
end
 
class Window_Status < Window_Selectable
  
  def custom_param_list_1
    [
      { name: "ATK", value: @actor.param(2), icon_index: 34 },
      { name: "DEF", value: @actor.param(3), icon_index: 35 },
      { name: "MAT", value: @actor.param(4), icon_index: 36 },
      { name: "MDF", value: @actor.param(5), icon_index: 37 },
      { name: "AGI", value: @actor.param(6), icon_index: 38 },
      { name: "LUK", value: @actor.param(7), icon_index: 39 },
      { name: "NEW", value: "???"                           },
      { name: "NEW", value: "???"                           },
      { name: "NEW", value: "???"                           }
    ]
  end
 
 
  def custom_param_list_2
    [ 
      { name: "Prec", value: (@actor.xparam(0)*100).to_s.split(".").first                 },
      { name: "Evas", value: (@actor.xparam(1)*100).to_s.split(".").first                 },
      { name: "Crít", value: (@actor.xparam(2)*100).to_s.split(".").first                 },
      { name: "Refl", value: (@actor.xparam(5)*100).to_s.split(".").first                 },
      { name: "CAtq", value: (@actor.xparam(6)*100).to_s.split(".").first                 },
      { name: "Farm", value: (@actor.sparam(3)*100).to_s.split(".").first                 },
      { name: "NEW",  value: "???"                                                        },
      { name: "NEW",  value: "???"                                                        },
      { name: "NEW",  value: "???"                                                        }
    ]
  end
 
  def custom_param_list_3
    [
      { name: "Fogo",   value: (@actor.element_rate(3)*100).to_s.split(".").first,  font_color: Color.new(215, 32, 32),icon_index: 96                                        },
      { name: "Água",   value: (@actor.element_rate(6)*100).to_s.split(".").first,  icon_index: 99                                        },
      { name: "Terra",  value: (@actor.element_rate(7)*100).to_s.split(".").first,  font_color: Color.new(120, 85, 70),   icon_index: 100 },
      { name: "Vento",  value: (@actor.element_rate(8)*100).to_s.split(".").first,  font_color: Color.new(0, 200, 0),     icon_index: 101 },
      { name: "Luz",    value: (@actor.element_rate(9)*100).to_s.split(".").first,  font_color: Color.new(200, 200, 0),   icon_index: 102 },
      { name: "Trevas", value: (@actor.element_rate(10)*100).to_s.split(".").first, font_color: Color.new(50, 50, 50),    icon_index: 103 },
      { name: "Gelo",   value: (@actor.element_rate(4)*100).to_s.split(".").first,  font_color: Color.new(0, 150, 250),   icon_index: 97  },
      { name: "Eletr",  value: (@actor.element_rate(5)*100).to_s.split(".").first,  font_color: Color.new(150, 0, 150),   icon_index: 98  },
      { name: "Magia",  value: (@actor.element_rate(1)*100).to_s.split(".").first,  font_color: Color.new(130, 200, 180), icon_index: 112 }
      
    ]
  end
 
  def custom_param_list_4
    [
      { name: "Veneno", value: (@actor.state_rate(2)*100).to_s.split(".").first, icon_index: 18 },
      { name: "Ceguei", value: (@actor.state_rate(3)*100).to_s.split(".").first, icon_index: 19 },
      { name: "Mudez",  value: (@actor.state_rate(4)*100).to_s.split(".").first, icon_index: 20 },
      { name: "Confu",  value: (@actor.state_rate(5)*100).to_s.split(".").first, icon_index: 21 },
      { name: "Sono",   value: (@actor.state_rate(6)*100).to_s.split(".").first, icon_index: 22 },
      { name: "Parali", value: (@actor.state_rate(7)*100).to_s.split(".").first, icon_index: 23 },
      { name: "Atord",  value: (@actor.state_rate(8)*100).to_s.split(".").first                 },
      { name: "Congel", value: (@actor.state_rate(28)*100).to_s.split(".").first                },
      { name: "Petrif", value: (@actor.state_rate(29)*100).to_s.split(".").first                }
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
    x = 0
    custom_param = [custom_param_list_1, custom_param_list_2, custom_param_list_3, custom_param_list_4]
 
    custom_param.each do |custom_param|
      draw_custom_param(x, y, custom_param)
      x += 136
    end
  end
 
  def draw_custom_param(x, y, param_list)
    line_width_base = WINDOW_STATUS_CONFIG::PARAM_WIDTH
 
    param_list.each_with_index do |param, index|
      # Cor do nome do parâmetro.
      font_color = param[:font_color] ||= system_color
      
      # Nome do parâmetro.
      change_color(font_color)
      draw_text(x + WINDOW_STATUS_CONFIG::ICON_WIDTH, y + line_height * index , line_width_base, line_height, param[:name])
      
      # Valor do parâmetro
      change_color(normal_color)
      draw_text(x + line_width_base, y + line_height * index, WINDOW_STATUS_CONFIG::PARAM_SPACE, line_height, param[:value], 2)
      
      # Imagem do ícone.
     if param[:icon_index]
        draw_icon(param[:icon_index], x, y + line_height * index) 
      end
    end
  end
end