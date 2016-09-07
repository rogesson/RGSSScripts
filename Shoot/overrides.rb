class Scene_Map < Scene_Base
  attr_accessor :shots

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
      #$game_player.turn_right_90
    end

    if Input.trigger?(:B)
      @shot = Shot.new
    end
  end

  def update_shot
    if @shot && @shot.active
      @shot.update
    end
  end
end