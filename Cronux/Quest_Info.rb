module QUEST_INFO
  def self.list
    [
      {
        'name'        => 'Ajustes iniciais',
        'description' => 'Falar com o capitão para saber qual será o próximo passo.',
        'active'      => false,
        'type'        => 'primária',
        'completed'   => false,
        'open'        => false,
        'rewards'     => [
                          { 'name' => 'Chave da Porta', 'amount' => 1 }
                         ]
      },
      {
        'name'        => 'Movendo os soldados',
        'description' => 'Reunir todo batalhão para iniciar a caçada.',
        'active'      => false,
        'type'        => 'primária',
        'completed'   => false,
        'open'        => false,
        'rewards'     => [
                          { 'name' => 'Semente da Vida', 'amount' => 1 },
                          { 'name' => 'Pedra Inscrita', 'amount' => 2 }
                         ]

      }
    ]
  end
end