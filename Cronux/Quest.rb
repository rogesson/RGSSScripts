class Quest
  attr_reader :name, :description, :type, :completed, :rewards
  attr_accessor :new_quest, :open

  def initialize(name, description, new_quest, type, completed, open, rewards)
    @name        = name
    @description = description
    @new_quest   = new_quest
    @type        = type
    @completed   = completed
    @open        = open
    @rewards     = rewards
  end

  def start_quest
    self.new_quest = true
  end

  def enable_quest
    self.open = true
    $scene.window_new_quest = Window_NewQuest.new(self)
  end
end