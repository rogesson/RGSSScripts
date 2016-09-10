class Shot
  attr_accessor :character

  attr_reader   :active
  attr_reader   :current_sprite
  attr_reader   :x
  attr_reader   :y

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

    execute_state do
      if @state != :explosion
        update_position
      end

      if @state == :explosion && !@state_executed
        @x -= 30
        @y -= 30
      end
    end

    @animate.execute

    if @animate && @lifetime > @time_to_die
      @active = false
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
    @direction =  case @weapon_direction
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

    @x = screen_x
    @y = screen_y
  end

  def update_position
    case @direction
    when :up
      @y -= @speed
    when :right
      @x += @speed
    when :down
      @y += @speed
    when :left
      @x -= @speed
    end

    @current_sprite[:sprite].x = @x
    @current_sprite[:sprite].y = @y
  end

  def set_bitmap(name, angle = 0, mirror = false)
    @current_sprite[:sprite] ||= Sprite.new
    @current_sprite[:sprite].bitmap = Cache.system(name)
    @current_sprite[:sprite].angle  = angle
    @current_sprite[:sprite].mirror = mirror
  end

  def set_animate(images, repeat = false, chain = false)
    @animate = Animate.new(self, @current_sprite[:sprite], images, repeat, chain)
  end

  def execute_state(&block)
    old_state = @state

    new_state = case @lifetime
                when 0..1
                  :lauched
                when 20..25
                  :explosion
                end

    if old_state != new_state
      change_state(new_state)
    end

    yield if block_given?

    @state_executed = true
  end

  def change_state(state)
    return unless state

    @state = state
    config = Shot_State::state[state]
    @state_executed = false

    if config[:change_animation]
      set_bitmap(config[:animation_name])
      set_animate(config[:images], config[:repeat], config[:chain])
    end
  end
end