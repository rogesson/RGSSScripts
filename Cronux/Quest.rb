class Quest
  attr_reader :name, :description, :required_items, :rewards
  attr_accessor :in_progress, :open, :completed

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
    $scene.window_new_quest = Window_QuestMessages.new(self, true)
  end

  def can_finish?
    count_acquired_items
  end

  def finish_quest
    return unless can_finish?

    remove_requireds
    get_reward
    self.in_progress = false
    self.completed = true
    $scene.window_nav_quest.update

    finish_message
  end

  def verify_requirements
    @required_items.each do |required_item|
      item = inventory_items.find { |i| i.id == required_item['id'] }
      required_item['acquired'] = count_item(item)
    end
  end

  private

  def remove_requireds
    @required_items.each do |required_item|
      remove_item($data_items[required_item['id']],  required_item['amount'])
    end
  end

  def get_reward
    rewards.each do |reward|
      item = $data_items[reward['id']]
      gain_item(item, reward['amount'])
    end
  end

  def count_item(item)
    case item
    when RPG::Item
       $game_party.item_number(item.id)
    when RPG::Weapon
      $game_party.weapon_number(item.id)
    when RPG::Armor
      $game_party.armor_number(item.id)
    end
  end

  def count_acquired_items
    verify_requirements

    completed = []
    @required_items.each do |item|
      completed.push(item['acquired'].to_i >= item['amount'])
    end

    !completed.include?(false)
  end

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

  def remove_item(item, amount)
    case item
    when RPG::Item
      $game_party.lose_item(item.id, amount)
    when RPG::Weapon
      $game_party.lose_weapon(item.id, amount)
    when RPG::Armor
      $game_party.lose_armor(item.id, amount)
    end
  end

  def finish_message
    $scene.window_new_quest = Window_QuestMessages.new(self, false)
  end

  def inventory_items
    items = []

    for i in 1...$data_items.size
      items.push($data_items[i]) if $game_party.item_number(i) > 0
    end

    items
  end
end