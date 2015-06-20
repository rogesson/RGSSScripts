###########################################################################
# Clone
# Layer 1
Tile.new(1, 0, 1).copy_to(19, 0)

# Layer 2
Tile.new(1, 1, 2).copy_to(19, 1)

#Layer 3
Tile.new(1, 2, 3).copy_to(19, 2)


#Move
# Layer 1
Tile.new(1, 4, 1).move_to(19, 4)

# Layer 2
Tile.new(1, 5, 2).move_to(19, 5)

# Layer 3
#Tile.new(1, 6, 3).move_to(19, 6)

###########################################################################
# Teste move_to encadeado
t3 = Tile.new(1, 6, 3)
t3.move_to(19, 6)
t3.move_to(11, 11)

###########################################################################
# teste de passabilidade de tile.
Tile.new(8,8,3).make_passable

# Teste de controle de evento
Tile.new(1, 7).event.move_left