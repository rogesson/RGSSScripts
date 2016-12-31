class Game_Followers
  DIRECTIONS =  {
                  up:     8,
                  right:  6,
                  left:   4,
                  down:   2
                }

  alias prev_initialize initialize
  def initialize(leader)
    prev_initialize(leader)
    @switch_one = false
    @switch_two = false
  end

  alias prev_update update
  def update
    prev_update
    if Input.trigger?(:X)
      @switch_two = false
      gather
      @switch_one = true
    end

    if !moving? && !gathering? && @switch_one
      triangle_formation
    end
  end

  def move
    if @switch_two == false
      reverse_each {|follower| follower.chase_preceding_character }
    elsif @switch_two == true
      reverse_each {|follower| self.triangle_formation_follow }
    end
  end

  def triangle_formation_follow
    unless moving?
      each do |follower|
        follower.move_straight(Input.dir4) if Input.dir4 > 0
      end
    end
  end

  def is_passable?(d)
    passable_list = []

    each do |x|
      passable_list << x.is_passable?(d)
    end

    !passable_list.include?(false)
  end

  def triangle_formation
    case get_direction($game_player.direction)
    when :down
      self[0].move_straight(DIRECTIONS[:left])
      self[0].set_direction(DIRECTIONS[:down])

      self[1].move_straight(DIRECTIONS[:right])
      self[1].set_direction(DIRECTIONS[:down])

      self[2].move_straight(DIRECTIONS[:up])
      self[2].set_direction(DIRECTIONS[:down])
    when :left
      self[0].move_straight(DIRECTIONS[:up])
      self[0].set_direction(DIRECTIONS[:left])

      self[1].move_straight(DIRECTIONS[:down])
      self[1].set_direction(DIRECTIONS[:left])

      self[2].move_straight(DIRECTIONS[:right])
      self[2].set_direction(DIRECTIONS[:left])
    when :right
      self[0].move_straight(DIRECTIONS[:up])
      self[0].set_direction(DIRECTIONS[:right])

      self[1].move_straight(DIRECTIONS[:down])
      self[1].set_direction(DIRECTIONS[:right])

      self[2].move_straight(DIRECTIONS[:left])
      self[2].set_direction(DIRECTIONS[:right])
    when :up
      self[0].move_straight(DIRECTIONS[:right])
      self[0].set_direction(DIRECTIONS[:up])

      self[1].move_straight(DIRECTIONS[:left])
      self[1].set_direction(DIRECTIONS[:up])

      self[2].move_straight(DIRECTIONS[:down])
      self[2].set_direction(DIRECTIONS[:up])
    end

    @switch_one = false
    @switch_two = true
  end

  private

  def get_direction(direction_number)
    DIRECTIONS.key(direction_number)
  end
end

class Game_Player < Game_Character
  def move_by_input
    return if !movable? || $game_map.interpreter.running?
    if Input.dir4 > 0
      move_straight(Input.dir4)
    end
  end

  def move_straight(d, turn_ok = true)
    @followers.move if passable?(@x, @y, d)
    super
  end

  def movable?
    return false if moving?
    return false if @move_route_forcing || @followers.gathering?
    return false if @vehicle_getting_on || @vehicle_getting_off
    return false if $game_message.busy? || $game_message.visible
    return false if vehicle && !vehicle.movable?
    return false if !@followers.is_passable?(Input.dir4)

    return true
  end
end

class Game_Follower < Game_Character
  def initialize(member_index, preceding_character)
    super()
    @member_index = member_index
    @preceding_character = preceding_character
    @transparent = $data_system.opt_transparent
    @through = false
  end

  def is_passable?(d)
   passable?(@x, @y, d)
  end
end