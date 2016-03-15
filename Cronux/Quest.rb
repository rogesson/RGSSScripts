class Quest
  attr_reader :name, :description, :type, :completed, :open, :rewards
  attr_accessor :new_quest
  
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
    self.new_quest = false
  end
end