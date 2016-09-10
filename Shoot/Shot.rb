class Shot
  attr_accessor :active
  attr_accessor :character
  attr_accessor :x
  attr_accessor :y
  attr_accessor :direction
  attr_accessor :current_sprite

  def initialize
    @character        = character
    @lifetime         = 0
    @time_to_die      = 120
    @active           = true
    @speed            = 7
    @weapon_direction = $game_player.direction
    @current_sprite   = { sprite: nil }
    @state            = :lauching

    set_shot_direction
    set_initial_position
    set_bitmap('fire_shot', angle, mirror)
    set_animate(4, true)
  end

  def update
    return unless @active

    check_status

    if @state != :explosion
      update_position
      @current_sprite[:sprite].x = @x
      @current_sprite[:sprite].y = @y
    end

    @animate.execute

    if @animate && @lifetime > @time_to_die
      self.active = false
      @current_sprite[:sprite].dispose if @current_sprite[:sprite]
      @current_sprite[:sprite] = nil
    end

    @lifetime += 1
  end

  private

  def angle
    @direction == :up || @direction == :down ? 90 : 0
  end

  def mirror
    :left || @direction == :down
  end

  def set_shot_direction
    self.direction =  case @weapon_direction
                      when 8
                        :up
                      when 6
                        :right
                      when 2
                        :down
                      when 4
                        :left
                      end
  end

  def set_initial_position
    case @direction
    when :right
      screen_y = $game_player.screen_y - 40
      screen_x = $game_player.screen_x + 20
    when :left
      screen_y = $game_player.screen_y - 40
      screen_x = $game_player.screen_x - 80
    when :down
      screen_y = $game_player.screen_y + 40
      screen_x = $game_player.screen_x - 20
    when :up
      screen_y = $game_player.screen_y - 40
      screen_x = $game_player.screen_x - 20
    end

    self.x = screen_x
    self.y = screen_y
  end

  def update_position
    case @direction
    when :up
      self.y -= @speed
    when :right
      self.x += @speed
    when :down
      self.y += @speed
    when :left
      self.x -= @speed
    end
  end

  def set_bitmap(name, angle = 0, mirror = false)
    @current_sprite[:sprite] ||= Sprite.new
    @current_sprite[:sprite].bitmap = Cache.system(name)
    @current_sprite[:sprite].angle = angle
    @current_sprite[:sprite].mirror = mirror
  end

  def set_animate(images, repeat = false, chain = false)
    @animate = Animate.new(self, @current_sprite[:sprite], images, repeat, chain)
  end

  def check_status
    old_state = @state

    new_state = case @lifetime
                when 0..1
                  :lauched
                when 20..25
                  :explosion
                end

    change_state(new_state) if old_state != new_state
  end

  def change_state(state)
    return unless state

    @state = state
    config = Shot_State::state[state]

    if config[:change_animation]
      set_bitmap(config[:animation_name])
      self.x -= 30
      self.y -= 30
      set_animate(config[:images], config[:repeat], config[:chain])
    end
  end
end