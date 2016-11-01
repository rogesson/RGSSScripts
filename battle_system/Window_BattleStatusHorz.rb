=begin
  Autor: Resque
  Data: 21/10/2016
  Email: rogessonb@gmail.com
=end

class Window_BattleStatusHorz < Window_Command
  def initialize
    super(105, 0)

    self.width = window_width
    refresh
    self.openness = 0
    self.opacity  = 0
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width - 128
  end

  def col_max
    return 4
  end

  def spacing
    return 8
  end

  def visible_line_number
    return 4
  end
  #--------------------------------------------------------------------------
  # * Get Window Height
  #--------------------------------------------------------------------------
  def window_height
    fitting_height(visible_line_number)
  end
  #--------------------------------------------------------------------------
  # * Get Number of Lines to Show
  #--------------------------------------------------------------------------

  #--------------------------------------------------------------------------
  # * Get Number of Items
  #--------------------------------------------------------------------------
  def item_max
    $game_party.battle_members.size
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # * Draw Item
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.battle_members[index]
    rect = gauge_area_rect(index)

    actor.screen_x = rect.x + 230
    actor.screen_y = 450
    #draw_basic_area(basic_area_rect(index), actor)
    draw_gauge_area(rect, actor)
  end
  #--------------------------------------------------------------------------
  # * Get Basic Area Retangle
  #--------------------------------------------------------------------------
  def basic_area_rect(index)
    rect = item_rect_for_text(index)
    rect.width -= gauge_area_width + 10
    rect
  end

  def gauge_area_rect(index)
    rect = item_rect_for_text(index)
    #rect.x += rect.width - gauge_area_width
    rect.x = 0
    rect.width = gauge_area_width
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Gauge Area Rectangle
  #--------------------------------------------------------------------------
  def gauge_area_rect(index)
    rect = item_rect_for_text(index)
    rect.x += rect.width - gauge_area_width
    rect.width = gauge_area_width
    rect
  end
  #--------------------------------------------------------------------------
  # * Get Gauge Area Width
  #--------------------------------------------------------------------------
  def gauge_area_width
    return 220
  end
  #--------------------------------------------------------------------------
  # * Draw Basic Area
  #--------------------------------------------------------------------------
  def draw_basic_area(rect, actor)
    draw_actor_name(actor, rect.x + 0, rect.y, 100)
    draw_actor_icons(actor, rect.x + 104, rect.y, rect.width - 104)
  end
  #--------------------------------------------------------------------------
  # * Draw Gauge Area
  #--------------------------------------------------------------------------
  def draw_gauge_area(rect, actor)
    if $data_system.opt_display_tp
      draw_gauge_area_with_tp(rect, actor)
    else
      draw_gauge_area_without_tp(rect, actor)
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Gauge Area (with TP)
  #--------------------------------------------------------------------------
  def draw_gauge_area_with_tp(rect, actor)
    side_pos = rect.x + 140
    draw_actor_name(actor, side_pos, rect.y, 100)
    draw_actor_hp(actor, side_pos, rect.y + 30, 72)
    draw_actor_mp(actor, side_pos, rect.y + 50, 72)
    draw_actor_tp(actor, side_pos, rect.y + 75, 72)
  end

  #--------------------------------------------------------------------------
  # * Draw Gauge Area (without TP)
  #--------------------------------------------------------------------------
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x + 0, rect.y, 134)
    draw_actor_mp(actor, rect.x + 144,  rect.y, 76)
  end
end
