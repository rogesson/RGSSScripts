class Card
  attr_accessor :sprite, :location
  attr_reader :selected

  def initialize(x, y)
    @x        = x
    @y        = y
    @location = :deck
    @selected = false

    create_sprite
  end

  def select
    return if @selected

    @sprite.y -= 10 if location == :hand

    @selected = true
  end

  def unselect
    return if !@selected
    @sprite.y += 10        if @location == :hand
    @sprite.opacity = 255  if @location == :field

    @selected = false
  end

  private

  def create_sprite
    sprite        = Sprite.new
    sprite.bitmap = Cache.system("deck")
    sprite.x      = @x
    sprite.y      = @y
    sprite.z      = 201

    @sprite = sprite
  end
end