#==============================================================================
# ** Syvkal's Menu Bars VXAce
#------------------------------------------------------------------------------
#  by Syvkal
#  Version 1.2
#  19-03-12
#------------------------------------------------------------------------------
# * Original available at:
#  www.rpgmakervxace.net  &  forums.rpgmakerweb.com
#  Please do not redistribute this script
#------------------------------------------------------------------------------
# * Terms of Use
#  Available for use in commercial games provided that I get a free copy :P
#  Email me: syvkal@hotmail.co.uk
#  Please do not redistribute this script
#==============================================================================
#
#  - INTRODUCTION -
#
#  This system implements a series of Plug 'N' Play Menu Bars/Gauges
#  The Bars (and some of the colour schemes) were inspired CogWheel,
#  but all coding was done by me
#
#------------------------------------------------------------------------------
#
#  - USAGE -
#
#  This system will work as soon as you put it in the Script Editor
#  You can edit the script from the Configuration System
#
#       --- Custom Gauges -----------------------------------
#
#  I have designed the script so you can easily (with minimal scripting
#  knowledge) add you own custom gauges for any attribute you want
#
#  To draw a gauge use:
#     draw_syvkal_gauge(x, y, width, rate, color1, color2, slant)
#
#     rate     : Percentage of your custom attribute max (full at 1.0)
#     color1   : left side gradient color
#     color2   : right side gradient color
#     style    : gauge draw style (explained in the Configuration System)
#
#       --- Auto Generate Color ---------------------------
#
#  Additionally, I have added an extra function to make it easy to
#  create your own colours that change as the gauge decreases
#
#  To generate a custom colour use:
#     auto_color(color1, color2, r)
#
#     r        : Percentage of your custom attribute max (full at 1.0)
#     color1   : Colour you want for when the gauge is full
#     color2   : Colour you want for when the gauge is nearly empty
#
#  This generates a SINGLE colour that changes with the gauge
#  Each gauge requires two colours so it has a gradient
#
#       --- Ring Bars -------------------------------------
#
#  Ring Bars have been removed for now, I didn't like how they looked
#  Testing has shown RGSS3 is more capable of the kind of ring bars I
#  wanted to make, but I want to perfect them first
#
#==============================================================================

            #===================================================#
            #  **   M I N O R   C O N F I G U R A T I O N   **  #
            #===================================================#

  #--------------------------------------------------------------------------
  # * Parameter Gauge Max
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  Minor addition allowing you to choose a max for the parameter gauges
  #  Best set just above your actor's highest stat (to allow for buffs)
  #  Excludes HP, MP, TP
  #  (This does not affect your actor's stats, but simply makes the gauges
  #   fill up quicker and look more appealing)
  #--------------------------------------------------------------------------
    P_MAX = 400                              # Parameter Gauge Max
  #-------------------------------------------------------------------------#
  #  **             Full Configuration system further down              **  #
  #-------------------------------------------------------------------------#

#==============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  Replaces various 'Draw' functions to add each gauge.
#==============================================================================
class Window_Base < Window

            #===================================================#
            #  **  C O N F I G U R A T I O N   S Y S T E M  **  #
            #===================================================#

  #--------------------------------------------------------------------------
  # * Gauge Draw Styles
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  Use different bracket types to 'draw' the style of each bar
  #  Available bracket types:
  #      (   )   <   >   |   /   \
  #  Simply mix and match for achieve your desired effect
  #
  #  To use the default rectangular gauges, use  |  or simply leave blank
  #  eg. '|       |'  or  ''
  #  Any invalid symbol will result in the default  |  as well
  #
  #      - - W A R N I N G - -
  #
  #  When using the following bracket:
  #      \
  #  Ensure it is followed a space (eg. '|    \ ') or itself (eg. '|    \\')
  #  If the rest of the text below turns purple, you've done it wrong
  #--------------------------------------------------------------------------
    HPSTYLE  = '/       >'                   # Style of the HP Gauge
    MPSTYLE  = '/       >'                   # Style of the MP Gauge
    TPSTYLE  = '/       >'                   # Style of the TP Gauge
    PARSTYLE = '/       >'                   # Style of the Parameter Gauges
  #--------------------------------------------------------------------------
  # * Additional Gauge Preferences
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  Simple adjustments to aesthetics
  #  Advised to use SLANTDSIZE if you have used / or \ in multiple bars
  #--------------------------------------------------------------------------
    THICKCURVED = false                      # Slightly thicken curved bars?
    SLANTDSIZE  = true                       # Shorten slanted bars?
  #--------------------------------------------------------------------------
  # * Gauge Border Colors
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  Control the colours of the gauge borders
  #--------------------------------------------------------------------------
    COLOR1 = Color.new(0, 0, 0, 192)         # Outer Border
    COLOR2 = Color.new(255, 255, 192, 192)   # Inner Border
  #--------------------------------------------------------------------------
  # * Empty Cauge Filler Colors
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  Control the colours of the empty gauge filler
  #--------------------------------------------------------------------------
    COLOR3 = Color.new(0, 0, 0, 12)          # Half of Inner Shading
    COLOR4 = Color.new(64, 0, 0, 92)         # Half of Inner Shading
  #--------------------------------------------------------------------------
  # * Paramater Gauge Colors
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  Control the colours of various parameters such as ATK, DEF, etc.
  #  (HP, MP, TP are in the 'Complex Configuration' section)
  #--------------------------------------------------------------------------
  def param_gauge_color1(param_id)
    case param_id
    when 2
      text_color(20)                         # ATK Gauge Color1
    when 3
      text_color(14)                         # DEF Gauge Color1
    when 4
      text_color(30)                         # MAT Gauge Color1
    when 5
      text_color(13)                         # MDF Gauge Color1
    when 6
      text_color(28)                         # AGI Gauge Color1
    when 7
      text_color(19)                         # LUK Gauge Color1
    end
  end
  def param_gauge_color2(param_id)
    case param_id
    when 2
      text_color(21)                         # ATK Gauge Color1
    when 3
      text_color(6)                          # DEF Gauge Color1
    when 4
      text_color(31)                         # MAT Gauge Color1
    when 5
      text_color(5)                          # MDF Gauge Color1
    when 6
      text_color(29)                         # AGI Gauge Color1
    when 7
      text_color(7)                          # LUK Gauge Color1
    end
  end

            #===================================================#
            #  ** C O M P L E X   C O N F I G U R A T I O N **  #
            #===================================================#

  #--------------------------------------------------------------------------
  # * HP Gauge Colors
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  Control the colours of the HP gauge
  #  (Edit only if you know what you're doing)
  #--------------------------------------------------------------------------
  def hp_gauge_color1                        # HP Guage Color1
    return Color.new(80 - 24 * @rate, 80 * @rate, 14 * @rate, 192)
  end
  def hp_gauge_color2                        # HP Guage Color2
    return Color.new(240 - 72 * @rate, 240 * @rate, 62 * @rate, 192)
  end
  #--------------------------------------------------------------------------
  # * MP Gauge Colors
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  Control the colours of the MP gauge
  #  (Edit only if you know what you're doing)
  #--------------------------------------------------------------------------
  def mp_gauge_color1                        # MP Guage Color1
    return Color.new(14 * @rate, 80 - 24 * @rate, 80 * @rate, 192)
  end
  def mp_gauge_color2                        # MP Guage Color2
    return Color.new(62 * @rate, 240 - 72 * @rate, 240 * @rate, 192)
  end
  #--------------------------------------------------------------------------
  # * TP Gauge Colors
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  Control the colours of the TP gauge
  #  (Edit only if you know what you're doing)
  #--------------------------------------------------------------------------
  def tp_gauge_color1                        # TP Gauge Color1
    return auto_color(Color.new(192,0,0,192), Color.new(255,110,0,192))
  end
  def tp_gauge_color2                        # TP Gauge Color2
    return auto_color(Color.new(255,165,0,192), Color.new(255,220,0,192))
  end

            #===================================================#
            #  **     E N D   C O N F I G U R A T I O N     **  #
            #===================================================#

  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :rate                     # Rate for Colour calculations
  #--------------------------------------------------------------------------
  # * Alias Listings
  #--------------------------------------------------------------------------
  alias draw_actor_param_original draw_actor_param
  alias initialize_original initialize
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    @rate = 1.0
    initialize_original(x, y, width, height)
  end
  #--------------------------------------------------------------------------
  # * Draw HP
  #--------------------------------------------------------------------------
  def draw_actor_hp(actor, x, y, width = 124)
    @rate = [actor.hp_rate, 1.0].min
    draw_syvkal_gauge(x, y, width, @rate, hp_gauge_color1, hp_gauge_color2, HPSTYLE)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::hp_a)
    draw_current_and_max_values(x, y, width, actor.hp, actor.mhp,
      hp_color(actor), normal_color)
  end
  #--------------------------------------------------------------------------
  # * Draw MP
  #--------------------------------------------------------------------------
  def draw_actor_mp(actor, x, y, width = 124)
    @rate = [actor.mp_rate, 1.0].min
    draw_syvkal_gauge(x, y, width, @rate, mp_gauge_color1, mp_gauge_color2, MPSTYLE)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::mp_a)
    draw_current_and_max_values(x, y, width, actor.mp, actor.mmp,
      mp_color(actor), normal_color)
  end
  #--------------------------------------------------------------------------
  # * Draw TP
  #--------------------------------------------------------------------------
  def draw_actor_tp(actor, x, y, width = 124)
    @rate = [actor.tp_rate, 1.0].min
    draw_syvkal_gauge(x, y, width, @rate, tp_gauge_color1, tp_gauge_color2, TPSTYLE)
    change_color(system_color)
    draw_text(x, y, 30, line_height, Vocab::tp_a)
    change_color(tp_color(actor))
    draw_text(x + width - 42, y, 42, line_height, actor.tp.to_i, 2)
  end
  #--------------------------------------------------------------------------
  # * Draw Parameters
  #     actor : actor
  #     x     : draw spot x-coordinate
  #     y     : draw spot y-coordinate
  #     type  : Type of parameters (0-3)
  #--------------------------------------------------------------------------
  def draw_actor_param(actor, x, y, param_id, width = 156)
    draw_syvkal_gauge(x, y, width, actor.params_rate(param_id), param_gauge_color1(param_id), param_gauge_color2(param_id), PARSTYLE)
    draw_actor_param_original(actor, x, y, param_id)
  end
  #--------------------------------------------------------------------------
  # * Auto Generate Color
  #     color1 : initial color
  #     color2 : ending color
  #     r      : rate (full at 1.0) 1 -> color1, 0 -> color2
  #--------------------------------------------------------------------------
  def auto_color(color1, color2, r = @rate)
    a_color = Color.new
    a_color.red = (1-r)*color2.red + r*color1.red
    a_color.green = (1-r)*color2.green + r*color1.green
    a_color.blue = (1-r)*color2.blue + r*color1.blue
    a_color.alpha = (1-r)*color2.alpha + r*color1.alpha
    return a_color
  end
  #--------------------------------------------------------------------------
  # * Draw Syvkal Style Gauge
  #     rate   : Rate (full at 1.0)
  #     color1 : Left side color
  #     color2 : Right side color
  #     style  : gauge draw style
  #--------------------------------------------------------------------------
  def draw_syvkal_gauge(x, y, width, rate, color1, color2, style = '')
    fill_w = (width * rate).to_i
    gauge_y = y + line_height - 8
    h = 6
    style.slice!(/\s*/); style = style.split(/\s*/)
    if style.empty? or (style[0] == '|' && style[1] == '|')
      contents.fill_rect(x-2, gauge_y-2, width+4, 10, COLOR1)
      contents.fill_rect(x-1, gauge_y-1, width+2, 8, COLOR2)
      contents.gradient_fill_rect(x, gauge_y, width, 6, COLOR3, COLOR4)
      contents.gradient_fill_rect(x, gauge_y, fill_w, 6, color1, color2)
    else
      adj1 = style_adj_string(style[0]); adj2 = style_adj_string(style[1], true)
      h += 4
      for i in 0...h
        a1 = eval(adj1[0]); a2 = eval(adj2[0])
        a3 = adj1[2]; a4 = adj2[4].nil? ? adj2[2] : adj2[4]
        contents.fill_rect(x-a3 +a1, gauge_y-2 + i, width+(a3+a4) - a1 - a2, 1, COLOR1)
      end
      h -= 2
      for i in 0...h
        a1 = eval(adj1[0]); a2 = eval(adj2[0])
        a3 = adj1[1]; a4 = adj2[3].nil? ? adj2[1] : adj2[3]
        contents.fill_rect(x-a3 +a1, gauge_y-1 + i, width+(a3+a4) - a1 - a2, 1, COLOR2)
      end
      h -= 2
      for i in 0...h
        a1 = eval(adj1[0]); a2 = eval(adj2[0])
        contents.gradient_fill_rect(x +a1, gauge_y +i, width - a1 - a2, 1, COLOR3, COLOR4)
      end
      for i in 0...h
        a1 = eval(adj1[0]); a2 = eval(adj2[0])
        contents.gradient_fill_rect(x +a1, gauge_y +i, fill_w - a1 - a2, 1, color1, color2)
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Get Style Specific Adjustment Array
  #     sym    : edge style '(', ')', '<', '>', '|', '/' or '\'
  #     edge   : end of the gauge?
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  Returns an array containing the following:
  #     * a formular string to be evaluated
  #     * adjustments to x and width values for Outer and Inner Borders
  #--------------------------------------------------------------------------
  def style_adj_string(sym, edge = false)
    case sym
    when '/'
      SLANTDSIZE ? [(edge ? 'i+2' : '(h+1) - i'), 3, 5] :
        [(edge ? 'i' : '(h-1) - i'), 3, 5]
    when '\\'
      SLANTDSIZE ? [(edge ? '(h+1) - i' : 'i+2'), 3, 5] :
        [(edge ? '(h-1) - i' : 'i'), 3, 5]
    when '<'
      [(edge ? '(h/2)-((h/2) - i).abs' : '((h/2) - i).abs'), 2, 3]
    when '>'
      [(edge ? '((h/2) - i).abs' : '(h/2)-((h/2) - i).abs'), 2, 3]
    when '('
      [(edge ? '((h/2) * Math.sin(i * 1.0 * Math::PI / (h-1))).round.to_i' :
        '(h-6) - ((h/2) * Math.sin(i * 1.0 * Math::PI / (h-1))).round.to_i'),
        THICKCURVED ? 3 : 2, THICKCURVED ? 5 : 4, 3, 5]
    when ')'
      [(edge ? '(h-3) - ((h/2) * Math.sin(i * 1.0 * Math::PI / (h-1))).round.to_i' :
        '((h/2) * Math.sin(i * 1.0 * Math::PI / (h-1))).round.to_i'),
        3, 5, THICKCURVED ? 3 : 2, THICKCURVED ? 5 : 4]
    else # eg. | or invalid sym
      ['0', 1, 2]
    end
  end
  #--------------------------------------------------------------------------
  # * Draw Gauge
  #--------------------------------------------------------------------------
  def draw_gauge(x, y, width, rate, color1, color2, style = '')
    r = [rate, 1.0].min
    draw_syvkal_gauge(x, y, width, r, color1, color2, style)
  end
end

#==============================================================================
# ** Game_BattlerBase
#------------------------------------------------------------------------------
#  Added specialised 'params_rate' function.
#==============================================================================

class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Get Percentage of Paramaters
  #--------------------------------------------------------------------------
  def params_rate(param_id)
    return [param(param_id).to_f / P_MAX, 1.0].min
  end
end

#==============================================================================
# ** Script Import
#==============================================================================

  $imported = {} if $imported == nil
  $imported["Syvkal's Menu Bars"] = true