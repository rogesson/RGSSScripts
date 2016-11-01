=begin
  Autor: Resque
  Data: 21/10/2016
  Email: rogessonb@gmail.com
=end

class Spriteset_Battle
  def create_enemies
    @enemy_sprites = $game_troop.members.reverse.collect do |enemy|
      Sprite_Battler.new(@viewport1, enemy)
    end
  end

  def create_actors
    @actor_sprites = $game_party.members.collect do |actor|
      Sprite_Battler.new(@viewport1, actor)
    end
  end
end

class Game_Actor < Game_Battler
  attr_accessor :screen_x
  attr_accessor :screen_y

  def initialize(actor_id)
    super()
    setup(actor_id)
    @last_skill = Game_BaseItem.new
  end

  def setup(actor_id)
    @actor_id = actor_id
    @name = actor.name
    @nickname = actor.nickname
    init_graphics
    @class_id = actor.class_id
    @level = actor.initial_level
    @exp = {}
    @equips = []
    init_exp
    init_skills
    init_equips(actor.equips)
    clear_param_plus
    recover_all

    @battler_name = actor.name
    @screen_x = 1200
    @screen_y = 1200
  end

  def use_sprite?
    return true
  end

  def screen_z
    return 100
  end
end

class Sprite_Battler < Sprite_Base
  def init_visibility
    @battler_visible = @battler.alive?
    self.opacity = 0 unless @battler_visible
  end
end

class Scene_Battle < Scene_Base
  def create_all_windows
    create_message_window
    create_scroll_text_window
    create_log_window
    create_status_window
    create_info_viewport
    create_party_command_window
    create_actor_command_window
    create_help_window
    create_skill_window
    create_item_window
    create_actor_window
    create_enemy_window
  end

  def create_party_command_window
    @party_command_window = Window_PartyCommandHoriz.new
    @party_command_window.viewport = @info_viewport
    @party_command_window.set_handler(:fight,  method(:command_fight))
    @party_command_window.set_handler(:escape, method(:command_escape))
    @party_command_window.unselect
  end

  def create_status_window
    @status_window = Window_BattleStatusHorz.new
  end

  def update_info_viewport
    move_info_viewport(0)   if @party_command_window.active
    move_info_viewport(328) if @actor_command_window.active
    move_info_viewport(64)  if BattleManager.in_turn?
  end

  def create_actor_command_window
    @actor_command_window = Window_ActorCommand.new
    @actor_command_window.set_handler(:attack, method(:command_attack))
    @actor_command_window.set_handler(:skill,  method(:command_skill))
    @actor_command_window.set_handler(:guard,  method(:command_guard))
    @actor_command_window.set_handler(:item,   method(:command_item))
    @actor_command_window.set_handler(:cancel, method(:prior_command))
  end

  def start_party_command_selection
    unless scene_changing?
      refresh_status
      @status_window.unselect
      @status_window.open
      if BattleManager.input_start
        @actor_command_window.close
        @party_command_window.setup
      else
        @party_command_window.deactivate
        turn_start
      end
    end
  end

  def turn_start
    @party_command_window.close
    @actor_command_window.close
    @status_window.unselect
    @subject =  nil
    BattleManager.turn_start
    @log_window.wait
    @log_window.clear
  end

  def update_message_open
    if $game_message.busy? && !@status_window.close?
      @message_window.openness = 0
      @status_window.close
      @party_command_window.close
      @actor_command_window.close
    end
  end

  def update_info_viewport
  end

  def command_attack
    BattleManager.actor.input.set_attack
    select_enemy_selection
  end
end

class Window_ActorCommand < Window_Command
  def initialize
    super(200, 250)
    self.opacity = 0
    self.openness = 0
    create_background
    close
    @actor = nil
  end

  def open
    super
    @background_sprite.opacity = 255
  end

  def close
    super

    @background_sprite.opacity = 0 if @background_sprite
  end

  def activate
    super
    @background_sprite.opacity = 255 if @background_sprite
  end

  private

  def create_background
    @background_sprite        = Sprite.new
    @background_sprite.bitmap = Cache.system("menu_actor_action")
    @background_sprite.x      = self.x - 35
    @background_sprite.y      = self.y - 30
  end
end

class Window_Base
  def initialize(x, y, width, height)
    super
    self.windowskin = Cache.system("Window")
    update_padding
    update_tone
    create_contents
    @opening = @closing = false
    self.back_opacity  = 130
  end
end