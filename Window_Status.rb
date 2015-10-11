=begin 
  * Script RGSS - RPG Maker VX ACE
  
  * Nome: Window Status
  * Descrição: Habilita novos parâmetros na tela de status.
  * Autor: Resque
  * Data: 11/10/2015
  * Link do pedido: http://www.mundorpgmaker.com.br/topic/113480-ajuste-em-script-simples/
=end

module WINDOW_STATUS_CONFIG
    PARAM_WIDTH = 55
end

class Window_Status < Window_Selectable
  
  def custom_param_list_1
    [
      { "Prec"  => (@actor.xparam(0)*100).to_s.split(".").first },
      { "Evas"  => (@actor.xparam(1)*100).to_s.split(".").first },
      { "Crít"  => (@actor.xparam(2)*100).to_s.split(".").first },
      { "C.Atq" => (@actor.xparam(6)*100).to_s.split(".").first },
      { "Refl"  => (@actor.xparam(5)*100).to_s.split(".").first },
      { "Farma" => (@actor.sparam(3)*100).to_s.split(".").first },
      { "New"     => "??" },
      { "New"     => "??" },
      { "New"     => "??" },
      { "New"     => "??" }
    ]
  end

  def custom_param_list_2
    [
      { "Fogo"    => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "Água"    => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "Terra"   => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "Vento"   => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "Sagrado" => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "Veneno"  => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "New"     => "??" },
      { "New"     => "??" },
      { "New"     => "??" },
      { "New"     => "??" }
    ]
  end

  def custom_param_list_3
    [
      { "Fogo"    => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "Água"    => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "Terra"   => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "Vento"   => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "Sagrado" => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "Veneno"  => (@actor.element_rate(3)*100).to_s.split(".").first },
      { "New"     => "??" },
      { "New"     => "??" },
      { "New"     => "??" },
      { "New"     => "??" }
    ]
  end

  def draw_parameters(x, y)
    10.times { |i| draw_actor_param(@actor, x, y + line_height * i, i + 2) }
  end

  def draw_actor_param(actor, x, y, param_id)
    param_name = (Vocab::param(param_id) || "New"  rescue "New")
    param_value = actor.param(param_id) rescue "??"

    change_color(system_color)
    draw_text(x, y, WINDOW_STATUS_CONFIG::PARAM_WIDTH, line_height, param_name)
    change_color(normal_color)
    draw_text(x + WINDOW_STATUS_CONFIG::PARAM_WIDTH, y, 50, line_height, param_value, 2)
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
    x = 5
    custom_param = [custom_param_list_1, custom_param_list_2, custom_param_list_3]

    draw_parameters(x, y)

    custom_param.each do |custom_param|
      x += 136
      draw_custom_param(x, y, custom_param)
    end
  end

  def draw_custom_param(x, y, param_list)
    line_width_base = WINDOW_STATUS_CONFIG::PARAM_WIDTH

    param_list.each_with_index do |param, index|
      change_color(system_color)
      draw_text(x, y + line_height * index , line_width_base, line_height, param.keys.first)
      change_color(normal_color)
      draw_text(x + line_width_base, y + line_height * index, 50, line_height, param.values.first, 2)
    end
  end
end
