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
    @shots = []
  end

  def update_scene
    check_gameover
    update_transfer_player unless scene_changing?
    update_encounter       unless scene_changing?
    update_action          unless scene_changing?
    update_call_debug      unless scene_changing?
    update_shot            unless scene_changing?
  end

  def update_action
    if Input.trigger?(:C)
      #p @explosions.size
    end

    if Input.trigger?(:B)
      @shots << Shot.new
    end
  end

  def update_shot
    @shots.each { |shot | shot.update }

    @shots.delete_if {|s| !s.active }
  end
end