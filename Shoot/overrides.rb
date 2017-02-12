=begin
  Autor: Resque
  Script: This is part of Resque Shoot System
  Email: rogessonb@gmail.com
  Date: 24/09/2016
=end


module DataManager
  def self.create_game_objects
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $game_timer         = Game_Timer.new
    $game_message       = Game_Message.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
  end
end

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
    enemies_events

    @players.each_with_index do |player, i|
      player.state = :none
      player.player_hp = Player_HP.new(200)
      player.player_ai = Player_AI.new(player)
      player.player_ai.active = true
    end

    @hero.player_hp = Player_HP.new(100)
  end

  def enemies_events
    $game_map.events.values.each do |event|
      event.list.first.parameters.each do |param|
        @players << event if param == "<enemy>"
      end
    end
  end

  def update
    super
    $game_map.update(true)
    $game_player.update
    $game_timer.update
    #$global_delay_manager.update
    @spriteset.update
    update_scene if scene_change_ok?
  end

  def terminate
    super
    SceneManager.snapshot_for_background
    dispose_spriteset
    perform_battle_transition if SceneManager.scene_is?(Scene_Battle)

   @hero.player_hp.terminate
    @players.each do |p|
      p.player_hp.terminate
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

    if @player_hp
      @player_hp.screen_x = self.screen_x
      @player_hp.screen_y = self.screen_y
      @player_hp.update
    end

    @player_ai.update  if @player_ai && player_ai.active
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
    @player_hp.damage(10)
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
