class Animate
  def initialize(resource, sprite, images, repeat=false)
    @resource            = resource
    @sprite              = sprite
    @position            = 0
    @frames              = 12
    @speed               = 10
    @bitmap_width        = @sprite.bitmap.width
    @single_image_width  = @bitmap_width / images
    @single_image_height = @sprite.bitmap.height
    @executed            = false

    reset_posisiton
  end

  def execute
    return if @executed
    @frames >= 60 ? update : @frames += @speed

    update_position
  end

  def reset_posisiton
    @sprite.src_rect.set(0, 0, @single_image_width, @single_image_height)
  end

  private

  def update
    @position += @single_image_width
    @position = 0 if @position >= @bitmap_width

    @sprite.src_rect.set(@position, 0, @single_image_width, @single_image_height)
    @frames = 0
  end

  def update_position
    @sprite.x = @resource.x
    @sprite.y = @resource.y
  end
end