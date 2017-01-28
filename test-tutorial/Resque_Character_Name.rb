class Resque_Character_Name
  def initialize(character)
    @character = character
    create_sprite

    @need_refresh = true
  end

  def update
    update_sprite_position
  end

  def update_sprite_position
    check_refresh

    return unless @need_refresh
    @sprite.x = @character.screen_x - 23
    @sprite.y = @character.screen_y

    @need_refresh = false
  end

  private

  def create_sprite
    @sprite        = Sprite.new
    @sprite.bitmap = Bitmap.new(name_size, 20)
    @sprite.bitmap.draw_text(0, 0, name_size, 20, "#{character_name}", 1)
  end

  def check_refresh
    @need_refresh = true if !sprite_same_y? || !sprite_same_x?
  end

  def sprite_same_x?
    @sprite.x == @character.screen_x
  end

  def sprite_same_y?
    @sprite.y == @character.screen_y
  end

  def name_size
    character_name.size * 9
  end

  def character_name
    @character.character_name
  end
end

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
    @resque_character_name = Resque_Character_Name.new($game_player)
  end

  def update
    super
    $game_map.update(true)
    $game_player.update
    $game_timer.update
    @spriteset.update
    @resque_character_name.update
    update_scene if scene_change_ok?
  end
end