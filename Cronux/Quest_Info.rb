module QUEST_INFO
  def self.list
    [
      {
        'name'           => 'Ajuda ao Próximo',
        'description'    => 'Encontre uma Poção em um baú escondido na floresta e ajude o caçador ferido.',
        'in_progress'    => false,
        'completed'      => false,
        'open'           => false,
        'force_accept'   => true,
        'required_items' => [
                              { 'id' => 1, 'amount' => 5, 'done' => false },
                              { 'talk' => 'Falar com o Rei',  'done' => false }
                            ],
        'rewards'        => [
                              { 'id' => 30, 'amount' => 100, 'gold' => true },
                              { 'id' => 10, 'amount' => 1 }
                            ]
      },
      {
        'name'           => 'Movendo os soldados',
        'description'    => 'Reunir todo batalhão para iniciar a caçada.',
        'in_progress'    => false,
        'completed'      => false,
        'open'           => false,
        'force_accept'   => false,
        'required_items' => [],
        'rewards'        => [
                              { 'id' => 1, 'amount' => 1 },
                              { 'id' => 20, 'amount' => 2 }
                            ]

      }
    ]
  end
end