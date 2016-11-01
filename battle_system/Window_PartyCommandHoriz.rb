=begin
  Autor: Resque
  Data: 21/10/2016
  Email: rogessonb@gmail.com
=end

class Window_PartyCommandHoriz < Window_ActorCommand
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    self.x = 340
    self.y = 20
    self.openness = 0
    self.opacity = 0
    create_background
    deactivate
  end
  #--------------------------------------------------------------------------
  # * Get Window Width
  #--------------------------------------------------------------------------
  def window_width
    return 200
  end

  def col_max
    2
  end

  #--------------------------------------------------------------------------
  # * Create Command List
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(Vocab::fight,  :fight)
    add_command(Vocab::escape, :escape, BattleManager.can_escape?)
  end
  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def setup
    clear_command_list
    make_command_list
    refresh
    select(0)
    activate
    open
  end

  def deactivate
    super

    @background_sprite.opacity = 0 if @background_sprite
  end

  def open
    super
    @background_sprite.opacity = 255
  end

  private

  def create_background
    @background_sprite        = Sprite.new
    @background_sprite.bitmap =  Cache.system("menu_party_actions")
    @background_sprite.x      = Graphics.width - 275
    @background_sprite.y      = Graphics.height - 140
  end
end
