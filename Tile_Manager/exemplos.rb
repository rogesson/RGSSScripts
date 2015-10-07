###########################################################################
# Clonagem de Tile

# Layer 1
# Clona a tile da posição 1,0 do layer 1 para a posição 19,0 do layer 1
Tile.new(1, 0, 1).copy_to(19, 0)

# Layer 2
# Clona a tile da posição 1,1 do layer 2 para a posição 19,1 do layer 2
Tile.new(1, 1, 2).copy_to(19, 1)

#Layer 3
# Clona a tile da posição 1,2 do layer 3 para a posição 19,2 do layer 2
Tile.new(1, 2, 3).copy_to(19, 2)

###########################################################################
# Movendo tile

# Layer 1
# Move a tile da posição 1,4 do layer 1 para a posição 19, 4 do layer 1
Tile.new(1, 4, 1).move_to(19, 4)

# Move a tile da posição 1,5 do layer 2 para a posição 19, 5 do layer 2
Tile.new(1, 5, 2).move_to(19, 5)

# Layer 3
# Move a tile da posição 1, 6 do layer 3 para a posição 19, 6 do layer 3
#Tile.new(1, 6, 3).move_to(19, 6)

###########################################################################
# Teste move_to encadeado (Tile)

# Tile que será movida duas vezes
t3 = Tile.new(1, 6, 3)

# Move a tile 1,6 para a posição 19, 6
t3.move_to(19, 6)
# Move a tile da posição 19, 6 para 11, 11
t3.move_to(11, 11)

###########################################################################
# Teste de passabilidade de tile.

# Torna a tile da posição 8, 8 do layer 3 passável
Tile.new(8, 8, 3).make_passable


# Bloqueia a tile passável da posição 5,8 do layer 3
#Tile.new(8, 8, 3).block

# Clona a tile 1,7 do layer 2 randômicamente
Tile.new(1, 7, 2).random_clone