class Player_AI
  def initialize(game_event)
    @game_event = game_event
    @active     = false
    @status     = :none
  end

  def update
    rand_number = rand(1000)
    @status = :chasing if rand(1000) < 15
    return if @status == :none

    chase if @status == :chasing
  end

  private

  def chase
    @game_event.move_toward_player
    @game_event.shoot
    @status = :none
  end
end