class Observer
  @shots.each { |shot | shot.update }

  @shots.delete_if {|s| !s.active }
end