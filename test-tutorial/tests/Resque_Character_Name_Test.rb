class Resque_Character_Name_Test < RTeste::Teste
  antes do
    @sujeito = Resque_Character_Name.new(game_character_base)
  end

  isso 'deve exibir o sprite do nome do personagem' do
    sprite = @sujeito.instance_variable_get(:@sprite)
    afirmar sprite.is_a? Sprite
  end

  isso 'deve exibir o bitmap do sprite do personagem' do
   sprite = @sujeito.instance_variable_get(:@sprite)
   afirmar sprite.bitmap.is_a? Bitmap
  end

  isso 'deve exibir o nome do personagem' do
    afirmar_igualdade @sujeito.send(:character_name), 'Resque'
  end

  isso 'deve ser verdadeiro apernas, quando a posição x ou y do sprite for diferente da posição do personagem' do
    afirmar @sujeito.instance_variable_get(:@need_refresh)

    @sujeito.update_sprite_position

    nao_afirmar @sujeito.instance_variable_get(:@need_refresh)
  end

  isso 'deve devolver o tamanho do nome do personagem' do
    afirmar @sujeito.send(:name_size) > 0
  end

  @sujeito = nil
end