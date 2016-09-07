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
    @current_sprite   = { sprite: nil }

    set_shot_direction
    set_initial_position
    create_bitmap
    create_animation
  end

  def update
    return unless @active

    @duration += 1

    update_position
    @animate.execute

    @current_sprite[:sprite].x = @x
    @current_sprite[:sprite].y = @y

    if @animate && @duration > @delay
      self.active = false
      @current_sprite[:sprite].dispose if @current_sprite[:sprite]
      @current_sprite[:sprite] = nil
    end

    p @current_sprite
  end

  private

  def set_angle
    @current_sprite[:sprite].angle = 90 if @direction == :up || @direction == :down
  end

  def set_mirror
    @current_sprite[:sprite].mirror = true if @direction == :left || @direction == :down
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

  def create_bitmap
    @current_sprite[:sprite] = Sprite.new
    @current_sprite[:sprite].bitmap = Cache.system("fire_shot")

    set_angle
    set_mirror
  end

  def create_animation
    @animate = Animate.new(self, @current_sprite[:sprite], 4, true)
  end
end