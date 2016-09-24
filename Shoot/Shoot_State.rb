module Shoot_State
  def self.state
    {
      lauching:  lauching,
      lauched:   lauched,
      explosion: explosion
    }
  end

  def self.lauching
    { change_animation: false }
  end

  def self.lauched
    { change_animation: false }
  end

  def self.explosion
    {
      change_animation: true,
      animation_name:   'explosion_0',
      images:           5,
      repeat:           true,
      chain:            3
    }
  end
end