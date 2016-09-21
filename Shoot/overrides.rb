class Scene_Map < Scene_Base

  def start
    super
    SceneManager.clear
    $game_player.straighten
    $game_map.refresh
    $game_message.visible = false
    create_spriteset
    create_all_windows
    @menu_calling = false
    @shots   = []
    @team    = []
    @enemies = []
    create_characters
  end

  def update_scene
    check_gameover
    update_transfer_player unless scene_changing?
    update_encounter       unless scene_changing?
    update_action          unless scene_changing?
    update_call_debug      unless scene_changing?
    update_shot            unless scene_changing?
    update_enemies         unless scene_changing?
  end

  def update_action
    if Input.trigger?(:C)
      enemie = @enemies.first[1]
    end

    if Input.trigger?(:B)
      @shots << Shot.new
    end
  end

  def update_shot
    @shots.each { |shot | shot.update }

    @shots.delete_if {|s| !s.active }

    @shots.each do |s|
      @enemies.each do |e|
        next if s.collided

        if ((s.real_x + 1) == e[1].real_x) && ((s.real_y + 1) == e.first[1].real_y)
          s.colide
        end
      end
    end
  end

  def update_enemies
    @enemies.each do |e|
      e.first[1].update_ai
    end
  end

  def create_characters
    @enemies << $game_map.events
    @enemies[0].first[1].state = :none
  end
end

class Game_Event < Game_Character
  attr_accessor :state

  def update_ai
    @status = :chasing if rand(1000) < 10

    return if @status == :none

    move_toward_player  if @status == :chasing
    @status = :none
  end
end