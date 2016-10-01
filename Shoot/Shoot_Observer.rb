=begin
  Autor: Resque
  Script: This is part of Resque Shoot System
  Email: rogessonb@gmail.com
  Date: 24/09/2016
=end

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
      @players.each do |player|
        match_coor(shoot, player[1])
      end

      match_coor(shoot, @scene_map.hero)
    end
  end

  def match_coor(shoot, player)
    if ((shoot.real_x + 1) == player.real_x.to_i) && ((shoot.real_y + 1) == player.real_y.to_i)
      colide(player, shoot)
    end
  end

  def colide(player, shoot)
    return if shoot.character == player
    return if shoot.collided

    if shoot.state != :explosion
      shoot.colide
      player.damage(10)
    end
  end
end