#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  This class performs the item screen processing.
#==============================================================================

class Window_Help < Window_Base

  #Diminuindo  a largura do conteudo da help_window
  def initialize(line_number = 2)
    grapics_width = Graphics.width

    # Se a scene atual for a Scene_Item_New
    if SceneManager.scene_is?(Scene_Item_New)
      grapics_width = grapics_width / 2  
    end

    super(0, 0, grapics_width, fitting_height(line_number))
  end

  def set_item(item)
    if item
      if SceneManager.scene_is?(Scene_Item_New)

        #Transofrma em short description se a scene for a da tela de item.
        description = short_description(item)
      else
        description = item.description
      end
      
      puts description
      set_text(item ?  description : "")
    end
  end

  # Exibe a descrição do item em várias linhas
  def short_description(item)
    format_item_description(item.description, 23)
  end

  # Formata o texto quebrando as linhas.
  def format_item_description(item_description, break_at)
    
    # Retorna a string formatada se a mesma já estiver formatada para evitar a recursividade.
    return item_description.gsub(/\n\s+/, "\n") if item_description.include? "\n"
    
    formated_description = String
    line_breaker         = break_at

    loop do
      begin
        item_description.insert(break_at, "\n")
        break_at = break_at + (line_breaker + 1)
        formated_description = item_description
      rescue
        # Sai do loop quando existir um erro de index nao encontrado,
        # isso significa que a a quebra de linha percorreu toda a string.
        break
      end 
    end

    formated_description.gsub(/\n\s+/, "\n")

#    Bitmap dos atributos do equipamento
#    self.contents = Bitmap.new(0, 0)
#    self.contents.draw_text(4, 0, self.width - 40, 32, "nome", 0)
#
  end

end

class Scene_Menu < Scene_MenuBase
  #Chamando a scene do novo menu.
  def command_item
    SceneManager.call(Scene_Item_New)
  end
end

class Window_ItemList < Window_Selectable
  #Mudando a lista de itens para vertical.
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
    $game_party.last_item.object = item
    determine_item
  end
  #--------------------------------------------------------------------------
  # * Item [Cancel]
  #--------------------------------------------------------------------------
  def on_item_cancel
    @item_window.unselect
    @category_window.activate
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
