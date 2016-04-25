class Quest
  attr_reader :name, :description, :completed, :required_items, :rewards
  attr_accessor :in_progress, :open

  def initialize(name, description, in_progress, completed, open, required_items, rewards)
    @name           = name
    @description    = description
    @in_progress    = in_progress
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

  def complete_quest
    rewards.each do |reward|
      gain_item(reward['id'], reward['amount'])
    end

    completed_alert
  end

  private

  def gain_item(item, amount)
    case item
    when RPG::Item
      $game_party.gain_item(item.id, amount)
    when RPG::Weapon
      $game_party.gain_weapon(item.id, amount)
    when RPG::Armor
      $game_party.gain_armor(item.id, amount)
    end
  end

  def completed_alert
    p 'Quest completa'
  end

  def get_party_items
    @items = []

    for i in 1...$data_items.size
      @items.push($data_items[i]) if $game_party.item_number(i) > 0
    end
  end

  def verify_requirements
    @required_items.each do |req_item|
      x = @items.find { |i| i.id == req_item['id'] }.nil?
      return false if @items.find { |i| i.id == req_item['id'] }.nil?
    end

    true
  end
end