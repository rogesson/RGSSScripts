class Quest
  attr_reader :name, :description, :type
  
  def initialize(name, description, type)
    @name        = name
    @description = description
    @type        = type
  end
end