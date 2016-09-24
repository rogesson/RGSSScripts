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
    create_characters
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
      #@shoot_observer.shoots << Shoot.new($game_player)
      $game_player.shoot
    end
  end

  def update_players
    return
    @players.each do |e|
      e.first[1].update_ai
    end
  end

  def create_characters
    @players << $game_map.events
    @players[0].first[1].state = :none
    @players[0].first[1].map_hp = 100
  end
end

class Game_Event < Game_Character
  attr_accessor :state

  attr_accessor :map_hp

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
end