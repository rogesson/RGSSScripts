=begin 
  * Script RGSS(XP) para RPG Maker VX ACE
  
  * Nome: Menu 
  * Descrição: Muda Layout e informações do menu de item.
  * Autor: Resque
  * Data: 10/12/2014
=end

#==============================================================================
# ** Scene_Item_new  [TODO] Mudar este nome.
# 
# **   
#------------------------------------------------------------------------------
#  Script responsável por editar a tela de item.
#==============================================================================

# Classe responsável por exibir as informações do item selecionado.
class Item_Info_Window < Window_Base
  attr_accessor :current_item

  def initialize(x, y, width, height)
    super(x, y, width, height)
    @current_item = nil
  end
  
  #--------------------------------------------------------------------------
  # * set_text
  #--------------------------------------------------------------------------
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    
    if SceneManager.scene_is?(Scene_Item_New) and @current_item
     draw_item_informations
    else
      draw_text_ex(4, 0, @text)
    end
  end

  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    set_text("")
  end

  #--------------------------------------------------------------------------
  # * Return type item type.
  #--------------------------------------------------------------------------
  def item_type
    if @current_item.is_a? RPG::Weapon
      $data_system.weapon_types[@current_item.wtype_id]
    else 
      $data_system.armor_types[@current_item.atype_id]
    end
  end

  #--------------------------------------------------------------------------
  # * Return element name.
  #--------------------------------------------------------------------------
  def item_element
      element_index = @current_item.features.first.data_id.to_i
      $data_system.elements[element_index]
  end
  #--------------------------------------------------------------------------
  # * set_item
  #--------------------------------------------------------------------------
  def set_item(item)
    self.current_item = item
    #--------------------------------------------------------------------------
    # * Atualiza janela de informações do item.
    #--------------------------------------------------------------------------
    return if  !SceneManager.scene_is?(Scene_Item_New) or !item
    
    #--------------------------------------------------------------------------
    # * Adiciona quebra de linhas na descrião do item se a scene for a da tela
    # * de item.
    #--------------------------------------------------------------------------
    description = short_description(item)

    #--------------------------------------------------------------------------
    # * Exibe descrição do item selecionado.
    #--------------------------------------------------------------------------
    set_text(item ?  description : "")
  end

  #--------------------------------------------------------------------------
  # * Exibe a descrição do item em várias linhas
  #--------------------------------------------------------------------------
  def short_description(item)
    format_item_description(item.description, 23)
  end

  #---------------------------------------------------------------------------
  # * Metodo que formata o texto da descrição do item quebrando as linhas.
  #---------------------------------------------------------------------------
  def format_item_description(item_description, break_at)
    #--------------------------------------------------------------------------
    # * Retorna a string formatada se a mesma já estiver formatada para evitar a recursividade.
    #--------------------------------------------------------------------------
    return item_description.gsub(/\n\s+/, "\n") if item_description.include? "\n"
    
    formated_description = String
    line_breaker         = break_at

    loop do
      begin
        item_description.insert(break_at, "\n")
        break_at = break_at + (line_breaker + 1)
        formated_description = item_description
      rescue
        #--------------------------------------------------------------------------
        # * Sai do loop quando existir um erro de index nao encontrado,
        # * isso significa que a a quebra de linha percorreu toda a string.
        #--------------------------------------------------------------------------
        break
      end
    end

    formated_description.gsub(/\n\s+/, "\n")
  end

  #---------------------------------------------------------------------------
  # * Exibe icone do item.
  #---------------------------------------------------------------------------
  def draw_item_icon
    draw_icon(@current_item.icon_index, 14, 20)
  end

  #---------------------------------------------------------------------------
  # * Exibe informações do item.
  #---------------------------------------------------------------------------
  def draw_item_info
    draw_text_ex(60, 4,  "Nome: #{@current_item.name}")
    draw_text_ex(60, 24, "Tipo: #{item_type}")
    draw_text_ex(60, 48, "Atributo: #{item_element}")
  end

  #---------------------------------------------------------------------------
  # * Exibe descrição do item.
  #---------------------------------------------------------------------------
  def draw_description
    draw_text_ex(8, 160, @text)
  end

  #---------------------------------------------------------------------------
  # * Exibe atributos do item na esquerda da janela.
  #---------------------------------------------------------------------------
  def draw_left_attributes
    draw_text_ex(8, 80,  %Q{ATK    > #{@current_item.params[2]}})
    draw_text_ex(8, 100, %Q{AGI    > #{@current_item.params[6]}})
    draw_text_ex(8, 120, %Q{MAX HP > #{@current_item.params[0]}})
  end

  #---------------------------------------------------------------------------
  # * Exibe atributos do item na direita da janela.
  #---------------------------------------------------------------------------
  def draw_right_attributes
    draw_text_ex(140, 80,  %Q{DEF    > #{@current_item.params[3]}})
    draw_text_ex(140, 100, %Q{SOR    > #{@current_item.params[7]}})
    draw_text_ex(140, 120, %Q{MAX MP > #{@current_item.params[1]}})
  end

  #---------------------------------------------------------------------------
  # * Exibe todas as informações do item.
  #---------------------------------------------------------------------------
  def draw_item_informations
    draw_item_icon
    draw_item_info
    draw_description
    draw_left_attributes
    draw_right_attributes
  end
end

class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Chamando a scene do novo menu.
  #--------------------------------------------------------------------------
  def command_item
    SceneManager.call(Scene_Item_New)
  end
end

class Window_ItemList < Window_Selectable
  #--------------------------------------------------------------------------
  # * Mudando a lista de itens para vertical.
  #--------------------------------------------------------------------------
  def col_max
    return 1
  end

  #--------------------------------------------------------------------------
  # * Removendo quantidade de item.
  #--------------------------------------------------------------------------
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      draw_item_name(item, rect.x, rect.y, enable?(item))
     #draw_item_number(rect, item)
    end
  end
end

# Override da Scene_Item_New
class Scene_Item_New < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_category_window
    create_item_window
    create_item_info_window
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ItemCategory.new
    @category_window.viewport = @viewport
    @category_window.y = 0
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # * Create Item Window
  #--------------------------------------------------------------------------
  def create_item_window
    wy = @category_window.y + @category_window.height
    wh = Graphics.height - wy

    @item_window_height = wh
    @item_window = Window_ItemList.new(0, wy, (Graphics.width / 2), wh)
    @item_window.viewport = @viewport
    
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))

    @category_window.item_window = @item_window
  end

  #--------------------------------------------------------------------------
  # * Cria a janela de informações do item selecionado.
  #--------------------------------------------------------------------------
  def create_item_info_window
    x       = @category_window.width / 2
    y       = @category_window.height
    width   = @category_window.width / 2
    height  = @item_window_height.to_i

    @item_info_window = Item_Info_Window.new(x, y, width, height)

    @category_window.help_window  = @item_info_window
    @item_window.help_window      = @item_info_window
  end

  #--------------------------------------------------------------------------
  # * Category [OK]
  #--------------------------------------------------------------------------
  def on_category_ok
    @item_window.activate
    @item_window.select_last
    @item_info_window.set_item(item)
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    $game_party.last_item.object = item
    determine_item
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
    @item_info_window.contents.clear if @item_info_window
  end
  #--------------------------------------------------------------------------
  # * Play SE When Using Item
  #--------------------------------------------------------------------------
  def play_se_for_item
    Sound.play_use_item
  end
  #--------------------------------------------------------------------------
  # * Use Item
  #--------------------------------------------------------------------------
  def use_item
    super
    @item_window.redraw_current_item
  end
end

#--------------------------------------------------------------------------
# * Override Window_Base
#--------------------------------------------------------------------------
class Window_Base < Window
  #--------------------------------------------------------------------------
  # * Override do draw_item_name
  #--------------------------------------------------------------------------
  def draw_item_name(item, x, y, enabled = true, width = 172)
    return unless item
    change_color(normal_color, enabled)
    draw_text(x, y, width, line_height, "#{item.name} #{draw_item_quantity}")
  end

  #--------------------------------------------------------------------------
  # * Override do draw_item_quantity
  #--------------------------------------------------------------------------
  def draw_item_quantity
    quantity = $game_party.item_number(item)
    "x#{quantity}" if quantity > 1
  end
end
