class FieldBase
  attr_accessor :sprite, :free, :card
  attr_reader :type

  def initialize(x, y)
    @x    = x
    @y    = y
    @free = true

    create_sprite
  end

  private

  def create_sprite
    sprite        = Sprite.new
    sprite.bitmap = Cache.system("field")
    sprite.x      = @x
    sprite.y      = @y
    sprite.z      = 201
    sprite.opacity = 50

    @sprite = sprite
  end
end