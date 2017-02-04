=begin
  Autor: Resque
  Script: This is part of Resque Shoot System
  Email: rogessonb@gmail.com
  Date: 24/09/2016
=end

class Player_HP
  attr_reader :current_hp
  attr_reader :max_hp
  attr_reader :sprite

  attr_accessor :screen_x
  attr_accessor :screen_y

  def initialize(hp)
    @max_hp     = hp
    @current_hp = hp

    create_sprite
    update_sprite
  end

  def hp_position
    x = (@screen_x - 60).to_i
    y = @screen_y.to_i

    { x: x, y: y }
  end

  def update
    return if same_position?

    update_position
  end

  def terminate
    @sprite.dispose
  end

  def damage(value)
    @current_hp -= value
    update_sprite
  end

  private

  def same_position?
    @sprite.x.to_i== hp_position[:x] && @sprite.y.to_i == hp_position[:y]
  end

  def update_position
    @sprite.x = hp_position[:x]
    @sprite.y = hp_position[:y]
  end

  def create_sprite
    @sprite        = Sprite.new
    @sprite.bitmap = Bitmap.new(120, 20)
  end

  def update_sprite
    @sprite.bitmap.clear
    @sprite.bitmap.draw_text(0, 0, 120, 20, "(#{@current_hp}/#{@max_hp})", 1)
  end
end