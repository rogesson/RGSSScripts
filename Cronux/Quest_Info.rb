module QUEST_INFO
  def self.list
    [
      {
        'name'        => 'Ajuda ao Próximo',
        'description' => 'Encontre uma Poção em um baú escondido na floresta e ajude o caçador ferido.',
        'active'      => false,
        'completed'   => false,
        'open'        => false,
        'required_items'    => [
                            { 'name' => 'Poção', 'amount' => 1 }
                         ],
        'rewards'     => [
                          { 'name' => 'Chave da Porta', 'amount' => 1 }
                         ]
      },
      {
        'name'        => 'Movendo os soldados',
        'description' => 'Reunir todo batalhão para iniciar a caçada.',
        'active'      => false,
        'completed'   => false,
        'open'        => false,
        'required_items' => [],
        'rewards'     => [
                          { 'name' => 'Semente da Vida', 'amount' => 1 },
                          { 'name' => 'Pedra Inscrita', 'amount' => 2 }
                         ]

      }
    ]
  end
end