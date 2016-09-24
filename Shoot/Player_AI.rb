class Player_AI
  attr_accessor :active

  def initialize(player)
    @player = player
    @active = false
    @status = :none
  end

  def update
    rand_number = rand(1000)
    @status = :chasing if rand(1000) < 15
    return if @status == :none

    chase if @status == :chasing
  end

  private

  def chase
    @player.move_toward_player
    @player.shoot
    @status = :none
  end
end