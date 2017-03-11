class Window_Info < Window_Base
  def initialize
    super(240, 0, 100, 50)
    self.z = 201
    self.openness = 0
    deactivate
  end
end