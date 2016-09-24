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

  def update_scene
    check_gameover
    update_transfer_player unless scene_changing?
    update_encounter       unless scene_changing?
    update_action          unless scene_changing?
    update_call_debug      unless scene_changing?
    @shoot_observer.update unless scene_changing?
  end

  def update_action
    if Input.trigger?(:C)
      call_menu
    end

    if Input.trigger?(:B)
      $game_player.shoot
    end
  end

  def initialize_players
    @players << $game_map.events
    @players.each do |p|
      p.first[1].state = :none
      p.first[1].player_hp = Player_HP.new(p.first[1], 200)
      p.first[1].player_ai = Player_AI.new(p.first[1])
      p.first[1].player_ai.active = true # Mudar
    end

    @hero.player_hp = Player_HP.new(@hero, 100)
  end

  def terminate
    super
    SceneManager.snapshot_for_background
    dispose_spriteset
    perform_battle_transition if SceneManager.scene_is?(Scene_Battle)

   @hero.player_hp.terminate
    @players.each do |p|
      p.first[1].player_hp.terminate
    end
  end
end

class Game_Character
  attr_accessor :shoot_delay
  attr_accessor :state
  attr_accessor :player_ai
  attr_accessor :player_hp

  def init_private_members
    super
    @move_route = nil                 # Move route
    @move_route_index = 0             # Move route execution position
    @original_move_route = nil        # Original move route
    @original_move_route_index = 0    # Original move route execution position
    @wait_count = 0                   # Wait count
    @shoot_delay = 0
  end

  def update
    super
    update_shot_delay
    @player_hp.update if @player_hp
    @player_ai.update   if @player_ai && player_ai.active
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

  def damage(shoot)
    @player_hp.current_hp -= 10
    if @player_hp.current_hp < 1
      die
    end
  end

  def die
    if self.player_ai
      moveto(500, 0)
      self.player_hp.terminate
      self.player_hp = Player_HP.new(self, 300)
    else
      SceneManager.goto(Scene_Gameover)
    end
  end
end