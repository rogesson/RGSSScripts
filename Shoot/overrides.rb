=begin
  Autor: Resque
  Script: Resque Battle System
  Email: rogessonb@gmail.com
  Date: 24/09/2016

  Note: Fell free to use this.
=end

class Scene_Map < Scene_Base
  attr_accessor :players
  attr_accessor :shoot_observer
  attr_reader   :hero
  def start
    super
    SceneManager.clear
    $game_player.straighten
    $game_map.refresh
    $game_message.visible = false
    create_spriteset
    create_all_windows
    @menu_calling = false
    @shoots  = []
    @team    = []
    @players = []
    @hero    = $game_player
    @shoot_observer = Shoot_Observer.new(SceneManager.scene)
    initialize_players
  end

  def shoot_list
    @shoots
  end

  def update_scene
    check_gameover
    update_transfer_player unless scene_changing?
    update_encounter       unless scene_changing?
    update_action          unless scene_changing?
    update_call_debug      unless scene_changing?
    update_players         unless scene_changing?
    @shoot_observer.update unless scene_changing?
  end

  def update_action
    if Input.trigger?(:C)
      enemie = @players.first[1]
    end

    if Input.trigger?(:B)
      $game_player.shoot
    end
  end

  def update_players
    @players.each do |e|
      e[1].update_ai
    end
  end

  def initialize_players
    @players << $game_map.events
    @players.each do |p|
      p.first[1].state = :none
      p.first[1].create_hp_bar
    end

    @hero.create_hp_bar
  end
end

class Game_Event < Game_Character
  attr_accessor :state

  def update_ai
    rand_number = rand(1000)
    @status = :chasing if rand(1000) < 15

    return if @status == :none

    if @status == :chasing
      move_toward_player
      shoot
      @status = :none
    end

    #if rand_number < 500
    #  shoot
    #end
  end
end

class Game_Character
  attr_accessor :shoot_delay
  attr_accessor :current_hp

  def init_private_members
    super
    @move_route = nil                 # Move route
    @move_route_index = 0             # Move route execution position
    @original_move_route = nil        # Original move route
    @original_move_route_index = 0    # Original move route execution position
    @wait_count = 0                   # Wait count
    @shoot_delay = 0

    @max_hp     = 100
    @current_hp = @max_hp
    @old_hp     = 0
  end

  def update
    super
    update_shot_delay
    update_value_hp_bar if @spr_bar
  end

  def update_shot_delay
    return if @shoot_delay == 0
    @shoot_delay -= 1 if @shoot_delay > 0
  end

  def shoot
    return if @shoot_delay > 0

    @shoot_delay = 100
    SceneManager.scene.shoot_observer.shoots << Shoot.new(self)
  end

  def create_hp_bar
    @spr_bar        = Sprite.new
    @spr_bar.bitmap = Bitmap.new(120, 20)
  end

  def update_value_hp_bar
    draw_hp_bar
    @spr_bar.x = self.screen_x - 60
    @spr_bar.y = self.screen_y
  end

  def draw_hp_bar
    if @current_hp != @old_hp
      @spr_bar.bitmap = Bitmap.new(120, 20)
      @spr_bar.bitmap.draw_text(0, 0, 120, 20, "(#{@current_hp}/#{@max_hp})", 1)
      @old_hp = @current_hp
    end
  end

  def damage(shoot)
    @current_hp -= 10

    if @current_hp < 1
     p 'morto'
    end
  end
end