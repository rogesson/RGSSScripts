=begin
  Autor: Resque
  Script: This is part of Resque Shoot System
  Email: rogessonb@gmail.com
  Date: 24/09/2016
=end

class Player_AI
  attr_accessor :active

  def initialize(player)
    @player = player
    @active = false
    @status = :none
    @executed = { shot: false }
  end

  def update
    chase
  end

  private

  def chase
    walk

    @status = :none
  end

  def walk
    $global_delay_manager.check_time([2, 70], @executed, :shoot) do
      if !@executed[:shoot]
        if rand(100) < 70
          @player.move_toward_player
          shoot
        else
          @player.move_random
        end
      end
    end
  end

  def shoot
    @player.shoot if rand(100) < 60
  end
end