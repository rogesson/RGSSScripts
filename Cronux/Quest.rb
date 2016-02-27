class Quest
  attr_reader :name, :description, :type, :completed, :rewards
  attr_accessor :new_quest
  
  def initialize(name, description, new_quest, type, completed, rewards)
    @name = name
    @description = description
    @new_quest = new_quest
    @type = type
    @completed = completed
    @rewards = rewards
  end

  def start_quest
    self.new_quest = false
  end
end