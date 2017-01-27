
# Sistema:    Resque Summoner System
# Autor:      Resque
# Email:      rogessonb@gmail.com
# Data:       27/01/2017
# Engine:     RPG MAKER Ace VX
# Linguagem:  RGSS3
# Utilização: Livre, desde que devidamente creditado.


# Descrição
# Invoca um monstro para lutar ao seu lado do grupo.



######################### Configuração #########################

module ResqueSummon
  # Level máximo que o summon pode ter.
  # Valor mínimo = 1
  SUMMON_MAX_LEVEL = 99

  # Opção de batalha do summon.
  # Caso o valor for (true), o summon atacará e
  # usará habilidades sozinho.
  # Caso o valor for (false), você controlará as ações.
  AUTO_BATTLE = true

  # Opção de consumir MP do invocador do summon quando o summon
  # executar alguma ação (ataque, skill, etc).
  # Para não consumir MP, o valor deverá ser (false).
  USE_MP_TO_KEEP_ALIVE = true

  # Valor de drenagem de mp caso a opção acima seja (true)
  # O invocador perderá uma porcentagem de MP quando o summon
  # executar uma ação.
  # Ex de valores:
  # 0.6 = 0,6% de drenagem
  # 1.0 = 1% de drenagem
  # 5.6 = 5,6% de drenagem
  # 70.2 = 70.2% de drenagem
  DRAIN_MP_PERCENTAGE = 0.6

  # Quantidade máxima de membros em batalha.
  # O summon será invocado apenas a quantidade de
  # de membros no grupo for menor do que o valor definido.
  MAX_ACTOR_SIZE = 4
end


######################### Script #########################


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
    summons.each { |summon| @actors.delete(summon) }

    $game_player.refresh
    $game_map.need_refresh = true
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

class Game_Summon < Game_Actor
  def initialize(monster_id, master)
    @master         = master
    @last_skill     = Game_BaseItem.new

    super(monster_id)
    setup(monster_id)
  end

  def setup(monster_id)
    @actor_id = monster_id
    @name = actor.name
    @enemy = $data_enemies[monster_id]
    @battler_name = @enemy.battler_name
    @nickname = @battler_name
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

  def actor
    $data_enemies[@actor_id]
  end

  def max_level
    ResqueSummon::SUMMON_MAX_LEVEL
  end

  def auto_battle?
    ResqueSummon::AUTO_BATTLE
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
    $game_party.clear_all_summons if @master.mp <= 0 && ResqueSummon::USE_MP_TO_KEEP_ALIVE
  end

  def drain_master_hp
    @master.mp = drain_rate
  end

  def drain_rate
    (@master.mp - (@master.mp * ResqueSummon::DRAIN_MP_PERCENTAGE / 100)).to_i
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
    return false if item.note.match(/<summon>/) && $game_party.actors.size >= ResqueSummon::MAX_ACTOR_SIZE
    $game_party.usable?(item)
  end
end