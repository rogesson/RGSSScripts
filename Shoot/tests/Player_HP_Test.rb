class Player_HP_Test < RTeste::Teste
  before do
    @player_hp = Player_HP.new(300)
  end

  isso "Deve ter 300 de HP Máximo" do
    afirmar_igualdade 300, @player_hp.max_hp
  end

  isso "Deve ter 300 de HP corrente" do
    afirmar_igualdade 300, @player_hp.current_hp
  end

  isso "Deve ficar na posição screen_x: 10, screen_y: 20" do
    @player_hp.screen_x = 70
    @player_hp.screen_y = 20

    afirmar_igualdade [10, 20], @player_hp.get_bar_position
  end

  isso "Deve desenhar a barra de HP" do
    afirmar_igualdade Sprite, @player_hp.sprite.class
    afirmar_desigualdade nil, @player_hp.sprite.bitmap
  end

  isso "Deve atualizar a barra de HP" do
    afirmar_igualdade true, @player_hp.update
  end

  isso "Não pode atualizar o HP, pois o tank não mudou de posição" do
    afirmar_igualdade false, @player_hp.update
  end

  isso "Deve atualizar a barra de HP, pois a posição do tank mudou" do
    @player_hp.screen_x = 100
    afirmar_igualdade true, @player_hp.update
  end

  isso "Deve reduzir 30 pontos de HP" do
    afirmar_igualdade true, @player_hp.damage(30)
    afirmar_igualdade 270, @player_hp.current_hp
  end
end