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
    @executed = { shot: false, walk: false }
  end

  def update
    walk
    shoot
    update_rand_counter
  end

  private

  def chase
    walk

    @status = :none
  end

  def walk
    $global_delay_manager.check_time([90], @executed, :walk) do
      if !@executed[:walk]
        if @rand_counter < 70
          @player.move_toward_player
        else
          @player.move_random
        end
      end
    end
  end

  def shoot
    $global_delay_manager.check_time([2, 70], @executed, :shoot) do
      if !@executed[:shoot]
        if @rand_counter < 70
          @player.shoot
        end
      end
    end
  end

  def update_rand_counter
    @rand_counter = rand(100)
  end
end