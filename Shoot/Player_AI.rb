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
    @global_delay_manager  = GlobalDelayManager.new
  end

  def update
    @global_delay_manager.update

    chase
    #rand_number = rand(1000)
    #@status = :chasing if rand(1000) < 10
    #return if @status == :none

    #chase if @status == :chasing
  end

  private

  def chase
    walk

    @status = :none
  end

  def walk
    @global_delay_manager.check_time(60) do
      if rand(100) < 70
        @player.move_toward_player
        shoot
      else
        @player.move_random
      end
    end
  end

  def shoot
    @player.shoot if rand(100) < 60
  end
end