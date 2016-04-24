class Quest
  attr_reader :name, :description, :completed, :rewards
  attr_accessor :in_progress, :open

  def initialize(name, description, in_progress, completed, open, required_items, rewards)
    @name           = name
    @description    = description
    @in_progress         = in_progress
    @completed      = completed
    @open           = open
    @required_items = required_items
    @rewards        = rewards
  end

  def start_quest
    self.in_progress = true
    can_finish?
  end

  def enable_quest
    return if open

    self.open = true
    $scene.window_new_quest = Window_NewQuest.new(self)
  end

  def can_finish?
    get_party_items
    verify_requirements
  end

  private

  def get_party_items
    @items = []

    for i in 1...$data_items.size
      @items.push($data_items[i]) if $game_party.item_number(i) > 0
    end
  end

  def verify_requirements
    @required_items.each do |req_item|
      return false if @items.find { |i| i.name == req_item['name'] }.nil?
    end
  end
end