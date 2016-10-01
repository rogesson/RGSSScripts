=begin
  Autor: Resque
  Script: This is part of Resque Shoot System
  Email: rogessonb@gmail.com
  Date: 24/09/2016
=end

class Animate
  def initialize(resource, sprite, images, repeat=false, chain=false)
    @resource            = resource
    @sprite              = sprite
    @position            = 0
    @frames              = 12
    @speed               = 10
    @bitmap_width        = @sprite.bitmap.width
    @single_image_width  = @bitmap_width / images
    @single_image_height = @sprite.bitmap.height
    @chain               = chain
    @chain_count         = 0

    reset_posisiton
  end

  def execute
    @frames >= 60 ? update : @frames += @speed

    update_position
  end

  def reset_posisiton
    @sprite.src_rect.set(0, 0, @single_image_width, @single_image_height)
  end

  private

  def update
    @position += @single_image_width

    @position = 0 if @position >= @bitmap_width && @repeat

    if @position >= @bitmap_width && @chain
      @chain_count += 1
      @position = 0
      create_bitmap
    end

    @sprite.src_rect.set(@position, 0, @single_image_width, @single_image_height)

    @frames = 0
  end

  def create_bitmap
    @sprite.bitmap = Cache.system("explosion_#{@chain_count}")
    set_angle
    set_mirror
  end

  def set_angle
    @sprite.angle = @resource.current_sprite[:sprite].angle
  end

  def set_mirror
    @sprite.mirror = @resource.current_sprite[:sprite].mirror
  end

  def update_position
    @sprite.x = @resource.x
    @sprite.y = @resource.y
  end
end