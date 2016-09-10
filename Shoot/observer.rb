class Observer
  def initialize(shot)

  end

  @shots.each { |shot | shot.update }

  @shots.delete_if {|s| !s.active }
end