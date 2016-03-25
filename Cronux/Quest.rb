class Quest
  attr_reader :name, :description, :type, :completed, :rewards
  attr_accessor :active, :open

  def initialize(name, description, active, type, completed, open, rewards)
    @name        = name
    @description = description
    @active      = active
    @type        = type
    @completed   = completed
    @open        = open
    @rewards     = rewards
  end

  def start_quest
    self.active = true
  end

  def enable_quest
    return if open

    self.open = true
    $scene.window_new_quest = Window_NewQuest.new(self)
  end
end