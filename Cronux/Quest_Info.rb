module QUEST_INFO
  def self.list
    [
      {
        'name'           => 'Ajuda ao Próximo',
        'description'    => 'Encontre uma Poção em um baú escondido na floresta e ajude o caçador ferido.',
        'in_progress'    => false,
        'completed'      => false,
        'open'           => false,
        'required_items' => [
                              { 'id' => 1, 'amount' => 5 }
                            ],
        'rewards'        => [
                              { 'id' => 10, 'amount' => 1 }
                            ]
      },
      {
        'name'           => 'Movendo os soldados',
        'description'    => 'Reunir todo batalhão para iniciar a caçada.',
        'in_progress'    => false,
        'completed'      => false,
        'open'           => false,
        'required_items' => [],
        'rewards'        => [
                              { 'id' => 1, 'amount' => 1 },
                              { 'id' => 20, 'amount' => 2 }
                            ]

      }
    ]
  end
end