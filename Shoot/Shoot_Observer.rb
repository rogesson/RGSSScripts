class Shoot_Observer
  attr_accessor :shoots

  def initialize(scene_map)
    @scene_map = scene_map
    @shoots    = []
    @players   = scene_map.players
  end

  def update
    return if @shoots.empty?

    update_shoots
    dispose_shoots
    check_collision
  end

  private

  def update_shoots
    @shoots.each { |shoot | shoot.update }
  end

  def dispose_shoots
    @shoots.delete_if {|s| !s.active }
  end

  def check_collision
    @shoots.each do |shoot|
      next if shoot.collided
      @players.each do |player|
        match_coor(shoot, player[1])
      end

      match_coor(shoot, @scene_map.hero)
    end
  end

  def match_coor(shoot, player)
    if ((shoot.real_x + 1) == player.real_x) && ((shoot.real_y + 1) == player.real_y)
      colide(shoot)
      player.damage(10)
    end
  end

  def colide(shoot)
    shoot.colide if shoot.state != :explosion
  end
end