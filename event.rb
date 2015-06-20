=begin 
  * Script RGSS(XP) para RPG Maker XP
  
  * Nome: Event
  * Descrição: Classe responsável por mapear e controlar os eventos do jogo.
  * Autor: Resque
  * Data: 20/06/2015
  
  * Features: 
    * Mapeia evento

  * Importando Script
    * Insira um novo script acima do Main chamado Evento
    * Copie e cole o Script abaixo dentro do Evento
=end

class Event
  def initialize(x, y)
    @x = x
    @y = y
    set_event
  end

  def event
    @event
  end

  private 

  def events
    $game_map.events.values
  end
  
  def set_event
    events.each { |evt| @event = evt if evt.x == @x and evt.y == @y }
  end
end