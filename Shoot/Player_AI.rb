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
    @event_list = { shot: false, walk: false }
  end

  def update
    walk
    shoot
    update_rand_counter
  end

  private

  def walk
    execute_event([90], :walk) do
      if @rand_counter < 70
        @player.move_toward_player
      else
        @player.move_random
      end
    end
  end

  def shoot
    execute_event([2, 70], :shoot) do
      @player.shoot if @rand_counter < 70
    end
  end

  def update_rand_counter
    @rand_counter = rand(100)
  end

  def execute_event(times, event_name)
    $global_delay_manager.check_time(times, @event_list, event_name) do
      if !@event_list[event_name]
        yield
      end
    end
  end
end