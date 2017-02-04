class Player_HP_Test < RTeste::Teste
  antes do
    sujeito { Player_HP.new(300) }
    sujeito.screen_x = 20
    sujeito.screen_y = 10
  end

  isso "Deve ter 300 de HP Máximo" do
    afirmar_igualdade 300, sujeito.max_hp
  end

  isso "Deve ter 300 de HP" do
    afirmar_igualdade 300, sujeito.current_hp
  end

  isso 'Deve ter a mesma posicao' do
    sujeito.send(:update_position)
    afirmar sujeito.send(:same_position?)
  end

  isso 'deve ter posicao diferente' do
    sujeito.screen_y = 15
    nao_afirmar sujeito.send(:same_position?)
  end

  isso 'deve criar o bitmap e o sprite do HP' do
    sujeito.send(:create_sprite)

    afirmar sujeito.instance_variable_get('@sprite').is_a?(Sprite)
    afirmar sujeito.instance_variable_get('@sprite').bitmap.is_a?(Bitmap)
  end
end