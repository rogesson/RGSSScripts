class Shot
  attr_accessor :active
  attr_accessor :character
  attr_accessor :x
  attr_accessor :y
  attr_accessor :direction

  def initialize
    @character        = character
    @duration         = 60
    @delay            = 89
    @active           = true
    @speed            = 10
    @weapon_direction = $game_player.direction
    @fired            = false

    set_shot_direction
    set_initial_position
  end

  def update
    @duration += 1

    if !@fired
      sprite        = Sprite.new
      sprite.bitmap = Cache.system("fire_shot")

      set_angle(sprite)
      set_mirror(sprite)

      @fired        = true
      @animate      = Animate.new(self, sprite, 4, true)
    else
      update_position
      @animate.execute
    end

    if sprite
      sprite.x = @x
      sprite.y = @y
    end

    if @animate && @duration > @delay
      self.active = false
      sprite.dispose if sprite
      sprite = nil
    end
  end

  private

  def set_angle(sprite)
    sprite.angle  = 90   if @direction == :up || direction == :down
  end

  def set_mirror(sprite)
    sprite.mirror = true if @direction == :left || @direction == :down
  end

  def set_shot_direction
    self.direction = case @weapon_direction
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
end