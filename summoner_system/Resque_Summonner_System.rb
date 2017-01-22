class Game_Party < Game_Unit
  attr_accessor :actors

  def add_actor(actor_id)
    @actors.push(actor_id) unless @actors.include?(actor_id)
    $game_player.refresh
    $game_map.need_refresh = true
  end

  def add_summon(monster_id, actor)
    @actors << Game_Summon.new(monster_id, actor)
    $game_player.refresh
    $game_map.need_refresh = true
  end

  def remove_summon
    @actors.pop
    $game_player.refresh
    $game_map.need_refresh = true
  end

  def clear_all_summons
    summons = []
    @actors.collect {|actor| summons << actor if actor.is_a?(Game_Summon) }
    summons.each { |sum| @actors.delete(sum) }
    $game_player.refresh
    $game_map.need_refresh = true
  end

  def usable?(item)
    members.any? {|actor| actor.usable?(item) }
  end
end

class Scene_Battle < Scene_Base
  def on_skill_ok
    @skill = @skill_window.item

    if @skill.note.match(/<summon>/)
      BattleManager.actor.input.set_skill(@skill.id)
      BattleManager.actor.last_skill.object = @skill
      @skill_window.hide
      $game_party.remove_summon

      next_command
    end

    BattleManager.actor.input.set_skill(@skill.id)
    BattleManager.actor.last_skill.object = @skill
    if !@skill.need_selection?
      @skill_window.hide
      next_command
    elsif @skill.for_opponent?
      select_enemy_selection
    else
      select_actor_selection
    end
  end

  def on_item_ok
    @item = @item_window.item
    BattleManager.actor.input.set_item(@item.id)

    if @item.note.match(/<summon>/)
      monster_id = @item.note.scan(/[0-9]+/).first.to_i
      $game_party.add_summon(monster_id, BattleManager.actor)
      @item_window.hide
      next_command

      return $game_party.last_item.object = @item
    end

    if !@item.need_selection?
      @item_window.hide
      next_command
    elsif @item.for_opponent?
      select_enemy_selection
    else
      select_actor_selection
    end
    $game_party.last_item.object = @item
  end
end

class Game_Actors
  def [](actor_id)
    if actor_id.is_a? Game_Summon
      return actor_id
    end

    return nil unless $data_actors[actor_id]
    @data[actor_id] ||= Game_Actor.new(actor_id)
  end
end

class Game_Actor < Game_Battler
  attr_accessor :summons

  def initialize(actor_id)
    super()
    setup(actor_id)
    @last_skill = Game_BaseItem.new
    @summons = []
  end
end

class Game_Summon < Game_Actor
  def initialize(monster_id, master)
    @master         = master
    @master.summons  << self
    @last_skill     = Game_BaseItem.new

    super(monster_id)
    setup(monster_id)
  end

  def setup(monster_id)
    @actor_id = monster_id
    @name = actor.name
    @enemy = $data_enemies[monster_id]
    @nickname = ''
    init_graphics
    @class_id = 1
    @level = @master.level
    @exp = {}
    @equips = []
    init_exp
    init_skills
    clear_param_plus
    recover_all
  end

  def use_sprite?
    return true
  end

  def summon?
    true
  end

  def actor
    $data_enemies[@actor_id]
  end

  def max_level
    99
  end

  def auto_battle?
    true
  end

  def init_skills
    @skills = []
    @enemy.actions.each do |action|
      learn_skill(action.skill_id)
    end
  end

  def init_graphics
    @character_name = @name
    @character_index = 3
    @face_name = 0
    @face_index = 0
  end

  def make_damage_value(user, item)
    value = item.damage.eval(user, self, $game_variables)
    value *= item_element_rate(user, item)
    value *= pdr if item.physical?
    value *= mdr if item.magical?
    value *= rec if item.damage.recover?
    value = apply_critical(value) if @result.critical
    value = apply_variance(value, item.damage.variance)
    value = apply_guard(value)

    if  user.is_a?(Game_Summon)
      drain_master_hp
      check_master_mp
    end

    @result.make_damage(value.to_i, item)
  end

  private

  def check_master_mp
    $game_party.clear_all_summons if @master.mp <= 0
  end

  def drain_master_hp
    @master.mp -= 6
  end
end

module BattleManager
  def self.process_victory
    play_battle_end_me
    replay_bgm_and_bgs
    $game_message.add(sprintf(Vocab::Victory, $game_party.name))
    $game_party.clear_all_summons
    display_exp
    gain_gold
    gain_drop_items
    gain_exp
    SceneManager.return
    battle_end(0)
    return true
  end
end

class Window_ItemList < Window_Selectable
  def enable?(item)
    return false if item.note.match(/<summon>/) && $game_party.actors.size >= 4
    $game_party.usable?(item)
  end
end