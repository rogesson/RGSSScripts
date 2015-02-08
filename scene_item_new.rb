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

      # Icone do Item.
      draw_icon(@current_item.icon_index, 8, 4)

      # Descrição do Item;
      draw_text_ex(4, 170, @text)
      
      # Informações do Item.
      draw_text_ex(60, 4,  "Nome:")
      draw_text_ex(60, 24, "Tipo: Foo")
      draw_text_ex(60, 48, "Atributo: Foo")

      # Atributos do Item.
      draw_text_ex(8, 120, %Q{ATK > #{rand(100)}  DEF > #{rand(100)}})
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
  # * set_item
  #--------------------------------------------------------------------------
  def set_item(item)

    self.current_item = item
    puts "updated #{rand 19}"
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

    
    "#{formated_description.gsub(/\n\s+/, "\n")}"
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

  #--------------------------------------------------------------------------
  # * Criando a janela de informações do item selecionado.
  #--------------------------------------------------------------------------
  def create_item_info_window
    x       = @category_window.width / 2
    y       = @category_window.height
    width   =  @category_window.width / 2
    height  = @item_window_height.to_i

    @item_info_window = Item_Info_Window.new(x, y, width, height)

    @category_window.help_window = @item_info_window
    @item_window.help_window = @item_info_window
  end
end
