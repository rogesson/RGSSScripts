class Quest
  attr_reader :name, :description, :type, :rewards
  
  def initialize(name, description, type, rewards)
    @name        = name
    @description = description
    @type        = type
    @rewards     = rewards
  end
end