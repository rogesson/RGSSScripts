module HUD_Config
  WINDOW_X        = 0
  WINDOW_Y        = 0

  WINDOW_WIDTH    = 200
  WINDOW_HEIGHT   = 150
  LINE_HEIGHT     = 24
end

class Window_HeroInfo < Window_Base
  @@count = 0
 
  def initialize
    super(HUD_Config::WINDOW_X, HUD_Config::WINDOW_Y, HUD_Config::WINDOW_WIDTH, HUD_Config::WINDOW_HEIGHT)
    @actor = $game_party.members.first
    print @actor.hp_rate
  end

  def refresh
    self.contents.clear
    draw_actor_information
  end

  private

  def draw_actor_information
    self.contents.draw_text(0, 0, 60, 24, "#{@@count}")
    @@count += 1
    #print @actor
    #draw_actor_name(@actor, 0, 0)
    #draw_actor_level(@actor, 0, 0 + HUD_Config::LINE_HEIGHT)
    #draw_actor_hp(@actor, 0, line_height * 2)
    #draw_actor_mp(@actor, 0, line_height * 3)
  end

  def update_hp
  end

  def update_mp
  end

  def need_update?
    @actor.hp_rate != $game_party.members.first.hp_rate
  end
end

class Scene_Map < Scene_Base
 alias hud_start     start
 alias hud_update    update
 alias hud_terminate terminate

  def start
    @window_hero_info = Window_HeroInfo.new
    hud_start
  end

  def update
    @window_hero_info.refresh
    hud_update
  end

  def terminate
    @window_hero_info.dispose
  end
end