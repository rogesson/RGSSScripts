class AnimateTest < RTeste::Teste
  antes do
    resource      = nil
    image_name    = 'explosion'
    sprite        = Sprite.new
    sprite.x      = 1
    sprite.y      = 1
    sprite.bitmap = Bitmap.new(32, 32)
    images_count  = 5
    repeat        = false
    chain         = false

    sujeito { Animate.new(sprite, image_name, images_count, repeat, chain) }
  end

  descrever '#execute' do
    isso 'isso deve atualizar o frame' do
      frames = sujeito.instance_variable_get('@frames')

      sujeito.execute
      afirmar sujeito.instance_variable_get('@frames') > frames
    end
  end

  descrever '#update_frames' do
    isso 'isso deve atualizar o frame' do
      frames = sujeito.instance_variable_get('@frames')

      sujeito.send(:update_frames)
      afirmar sujeito.instance_variable_get('@frames') > frames
    end
  end

  #descrever '#update' do
  #  isso 'deve atualizar a imagem' do
  #    sujeito.send(:update)
  #  end
  #end
end