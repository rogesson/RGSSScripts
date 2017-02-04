class AnimateTest < RTeste::Teste
  antes do
    resource     = nil
    sprite       = Sprite.new
    images_count = 5
    repeat       = false
    chain        = false

    sujeito { Animate.new(resource, sprite, images_count, repeat, chain) }
  end
end