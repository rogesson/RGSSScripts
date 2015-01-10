#==============================================================================
# ** Scene_Item_new  [TODO] Mudar este nome.
# 
# **   
#------------------------------------------------------------------------------
#  Script responsável por editar a tela de item.
#==============================================================================

class Window_Help < Window_Base

  def initialize(line_number = 2)
    grapics_width = Graphics.width
    #--------------------------------------------------------------------------
    # * Diminui a largura do conteúdo da help_window se a scene atual for a Scene_Item_New
    #--------------------------------------------------------------------------
    if SceneManager.scene_is?(Scene_Item_New)
      grapics_width = grapics_width / 2  
    end

    super(0, 0, grapics_width, fitting_height(line_number))
  end

  def set_item(item)
    dispose_item_attribute
    return if !item
    #if SceneManager.scene_is?(Scene_Item_New)
      #--------------------------------------------------------------------------
      # * Adiciona quebra de linhas na descrião do item se a scene for a da tela
      # * de item.
      #--------------------------------------------------------------------------
      description = short_description(item)

      #--------------------------------------------------------------------------
      # * Exibe atributos do item.
      #--------------------------------------------------------------------------
      show_item_attribute(item)
    #else
    #  description = item.description
    #end
    
    #--------------------------------------------------------------------------
    # * Exibe descrição do item selecionado.
    #--------------------------------------------------------------------------
    set_text(item ?  description : "")
  end

  #--------------------------------------------------------------------------
  # * Exibe bitmap com atributos do item selecionado, Ex: ATK e DEF. 
  #--------------------------------------------------------------------------
  def show_item_attribute(item)
      dispose_item_attribute if @spr_item_attribute 
      
      item_attribute_info = %Q{ATK > 10  DEF > 40}
      bit = Bitmap.new(544, 416)
      bit.draw_text(286, 100, 300, 100, item_attribute_info)
      
      @spr_item_attribute = Sprite.new
      @spr_item_attribute.bitmap = bit
      
      @spr_item_attribute.z = 9999
  end

  #--------------------------------------------------------------------------
  # * Exibe bitmap com atributos do item selecionado, Ex: ATK e DEF. 
  #--------------------------------------------------------------------------
  def dispose_item_attribute
    return if  !SceneManager.scene_is?(Scene_Item_New)
    
    @spr_item_attribute.dispose if not @item and @spr_item_attribute
    @spr_item_attribute = nil
    puts 'disposed'
  end

  #--------------------------------------------------------------------------
  # * Exibe a descrição do item em várias linhas
  #--------------------------------------------------------------------------
  def short_description(item)
    format_item_description(item.description, 23)
  end

  #--------------------------------------------------------------------------
  # * Metodo que formata o texto da descrição do item quebrando as linhas.
  #--------------------------------------------------------------------------
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
end

# Override da Scene_Item_New
class Scene_Item_New < Scene_ItemBase
  #--------------------------------------------------------------------------
  # * Start Processing
  #--------------------------------------------------------------------------
  def start
    super
    create_help_window
    create_category_window
    create_item_window
    help_window_right
  end
  #--------------------------------------------------------------------------
  # * Create Category Window
  #--------------------------------------------------------------------------
  def create_category_window
    @category_window = Window_ItemCategory.new
    @category_window.viewport = @viewport
    @category_window.help_window = @help_window
    @category_window.y = 0
    @category_window.set_handler(:ok,     method(:on_category_ok))
    @category_window.set_handler(:cancel, method(:return_scene))
    help_window_right
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
    @item_window.help_window = @help_window
    @item_window.set_handler(:ok,     method(:on_item_ok))
    @item_window.set_handler(:cancel, method(:on_item_cancel))
    @category_window.item_window = @item_window
  end
  #--------------------------------------------------------------------------
  # * Category [OK]
  #--------------------------------------------------------------------------
  def on_category_ok
    @item_window.activate
    @item_window.select_last
  end
  #--------------------------------------------------------------------------
  # * Item [OK]
  #--------------------------------------------------------------------------
  def on_item_ok
    @help_window.dispose_item_attribute
    $game_party.last_item.object = item
    determine_item
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
    @help_window.dispose_item_attribute
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

  #--------------------------------------------------------------------------
  # * Modificando a Help_Window para que a mesma seja dividida em duas partes.
  #--------------------------------------------------------------------------
  def help_window_right
    @help_window.y      = @category_window.height
    @help_window.x      = @category_window.width / 2
    @help_window.height = @item_window_height.to_i
    @help_window.width  = @category_window.width / 2
  end
end
