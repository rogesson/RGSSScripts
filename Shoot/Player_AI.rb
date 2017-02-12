=begin
  Autor: Resque
  Script: This is part of Resque Shoot System
  Email: rogessonb@gmail.com
  Date: 24/09/2016
=end

class Player_AI
  attr_accessor :active

  def initialize(player)
    @player     = player
    @active     = false
    @status     = :none
    @event_list = { shot: false, walk: false }
    @walk_delay = Delay.new(35)
    @shot_delay = Delay.new(120)
  end

  def update
    update_walk
    update_shoot
  end

  private

  def update_walk
    @walk_delay.update

    if @walk_delay.fire
      @player.move_toward_player
      @walk_delay.reset_rand
    end
  end

  def update_shoot
    @shot_delay.update

    if @shot_delay.fire
      @player.shoot
      @shot_delay.reset_rand
    end
  end
end