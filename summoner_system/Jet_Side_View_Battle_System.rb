#===============================================================================
# Jet's Viewed Battle System
# By Jet10985(Jet)
#===============================================================================
# This script will add actor sprites into the battle scene.
# This script has: 10 customization options.
#===============================================================================
# Overwritten Methods:
# Game_Actor: use_sprite?, screen_x, screen_y
# Sprite_Battler: revert_to_normal
# Scene_Battle: show_attack_animation
#-------------------------------------------------------------------------------
# Aliased methods:
# Game_Enemy: screen_x, screen_y
# Sprite_Battler: update_origin, update_bitmap
# Window_BattleEnemy: update
# Window_BattleActor: update
# Window_ActorCommand: update
#===============================================================================
=begin
Set an enemy's attack animation by using this in their notebox:

<anim: 50>

Replace 50 with the animation id.
--------------------------------------------------------------------------------
You may use a sprite for a monster instead of a regular battler by using this
notetag in the monster's notebox:

<sprite: ImageName, 0>

Replace ImageName with the name of the spritesheet, and 0 with the index on the
spritesheet you want the monster to use.
=end

module Jet
  module VBS

    # Which direction do actors face on the field? There are 4 options:
    # :up, :down, :left, or :right. Actor's will direction chosen.
    ACTOR_ORIENTATION = :left

    # This will make it so actor's are centered on the screen instead of being
    # placed in pre-determined lines using START_POINT and SPACE_DIFFERENCE.
    CENTER_ACTORS = false

    # This is the x and y starting point for actors. This option may take one of
    # 2 functions. If CENTER_ACTORS is true, and ACTOR_ORIENTATION is either
    # :left, or :right, then only the x value will be used as where to center
    # the actors. If it is :down or :up, only the y value will be used.
    # If CENTER_ACTORS is false, then this is where actor's will begin to be
    # placed on screen.
    START_POINT = [345, 200]

    # This is how much space is between each actor on the field.
    SPACE_DIFFERENCE = 27

    # If you're using the :left or :right view, this will push each
    # subsequent actor back by a certain number of pixels, to avoid having
    # a straight line.
    SIDEVIEW_PUSH_BACK = 18

    # Do you want to reverse the direction and field during an ambush?
    # (This is when enemies surprise the player and get the first turn)
    REVERSE_FIELD_FOR_AMBUSH = true

    # this is how far the actor will move forward when they are selection an
    # action, as well as executing it.
    SLIDE_AMOUNT = 127

    # This is how far the actor will slide each frame until they reach their
    # goal of SLIDE_FORWARD. Best used when this is a factor of SLIDE_FORWARD.
    FRAME_SLIDE = 20

    # During selecting an actor command, and during selecting an enemy target,
    # would you like the selected character to flash?
    DO_FLASH = true

    # These are state-based sprite changes. If the actor has one of these states
    # then the game will search for a sprite of the character's regular sprite
    # name with the special state tag appended to it. So if Jimmy's sprite
    # name was $Jimmy, and he had poison inflcted on him, and poison's id was
    # listed here as ["_poison", 0], it would change Jimmy's in-battle sprite
    # to $Jimmy_poison at the first sprite index.
    STATE_SPRITES = {

      1 => ["", 0],
      2 => ["", 0]

    }

    # Do not touch this option.
    DIR_ORIENT = {right: 6, left: 4, down: 2, up: 8}[ACTOR_ORIENTATION]

  end
end

#===============================================================================
# DON'T EDIT FURTHER UNLESS YOU KNOW WHAT TO DO.
#===============================================================================
class Integer

  def even?
    self % 2 == 0
  end

  def odd?
    !even?
  end
end

class RPG::Enemy

  def animation
    (f = note.match(/<anim:[ ]*(\d+)>/i)) ? f[1].to_i : 1
  end

  def battle_sprite
    (f = note.match(/<sprite:[ ]*(.+),[ ]*(\d+)>/i)) ? f[1..2] : false
  end
end

module BattleManager

  class << self

    alias jet3845_on_encounter on_encounter
    def on_encounter(*args, &block)
      jet3845_on_encounter(*args, &block)
      @true_surprise = @surprise
    end
  end

  def self.true_surprise
    @true_surprise ||= false
  end

  def self.player_dir
    if @true_surprise && Jet::VBS::REVERSE_FIELD_FOR_AMBUSH
      return 10 - Jet::VBS::DIR_ORIENT
    else
      return Jet::VBS::DIR_ORIENT
    end
  end
end

class Game_Actor

  def use_sprite?
    true
  end

  def screen_x
    if [8, 2].include?(BattleManager.player_dir)
      if Jet::VBS::CENTER_ACTORS
        x = Graphics.width / 2
        x -= 16
        x += Jet::VBS::SPACE_DIFFERENCE / 2 if $game_party.members.size.even?
        x -= ($game_party.members.size / 2 - index) * Jet::VBS::SPACE_DIFFERENCE
        return x
      else
        return Jet::VBS::START_POINT[0] + Jet::VBS::SPACE_DIFFERENCE * index
      end
    end
    return Jet::VBS::START_POINT[0]
  end

  alias jet3745_screen_x screen_x
  def screen_x(*args, &block)
    x = jet3745_screen_x(*args, &block)
    case BattleManager.player_dir
    when 4
      x += Jet::VBS::SIDEVIEW_PUSH_BACK * index
    when 6
      x -= Jet::VBS::SIDEVIEW_PUSH_BACK * index
    end
    return x if !Jet::VBS::REVERSE_FIELD_FOR_AMBUSH
    x = Graphics.width - x if BattleManager.true_surprise && [6, 4].include?(BattleManager.player_dir)
    x
  end

  def screen_y
    if [6, 4].include?(BattleManager.player_dir)
      if Jet::VBS::CENTER_ACTORS
        y = Graphics.height / 2
        y -= 16
        y += Jet::VBS::SPACE_DIFFERENCE / 2 if $game_party.members.size.even?
        y -= ($game_party.members.size / 2 - index) * Jet::VBS::SPACE_DIFFERENCE
        return y
      else
        return Jet::VBS::START_POINT[1] + Jet::VBS::SPACE_DIFFERENCE * index
      end
    end
    return Jet::VBS::START_POINT[1]
  end

  alias jet3745_screen_y screen_y
  def screen_y(*args, &block)
    y = jet3745_screen_y(*args, &block)
    return y if !Jet::VBS::REVERSE_FIELD_FOR_AMBUSH
    y = Graphics.height - y if BattleManager.true_surprise && [8, 2].include?(BattleManager.player_dir)
    y
  end

  def screen_z
    101 + index
  end

  alias jet3745_character_name character_name
  def character_name(*args, &block)
    name = jet3745_character_name(*args, &block)
    return name unless SceneManager.scene_is?(Scene_Battle)
    states.sort {|a, b| b.priority <=> a.priority }.each {|a|
      if (add = Jet::VBS::STATE_SPRITES[a.id])
        return name + add[0]
      end
    }
    return name
  end

  alias jet3745_character_index character_index
  def character_index(*args, &block)
    index = jet3745_character_index(*args, &block)
    return index unless SceneManager.scene_is?(Scene_Battle)
    states.sort {|a, b| b.priority <=> a.priority }.each {|a|
      if (add = Jet::VBS::STATE_SPRITES[a.id])
        return index + add[1]
      end
    }
    return index
  end
end

class Game_Enemy

  alias jet3745_screen_x screen_x
  def screen_x(*args, &block)
    x = jet3745_screen_x(*args, &block)
    return x if !Jet::VBS::REVERSE_FIELD_FOR_AMBUSH
    x = Graphics.width - x if BattleManager.true_surprise && [6, 4].include?(BattleManager.player_dir)
    x
  end

  alias jet3745_screen_y screen_y
  def screen_y(*args, &block)
    y = jet3745_screen_y(*args, &block)
    return y if !Jet::VBS::REVERSE_FIELD_FOR_AMBUSH
    y = Graphics.height - y if BattleManager.true_surprise && [8, 2].include?(BattleManager.player_dir)
    y
  end

  def atk_animation_id1
    enemy.animation
  end

  def atk_animation_id2
    0
  end

  def bat_sprite?
    !!enemy.battle_sprite
  end

  def character_name
    enemy.battle_sprite[0]
  end

  def character_index
    enemy.battle_sprite[1].to_i
  end

  alias jet3745_character_name character_name
  def character_name(*args, &block)
    name = jet3745_character_name(*args, &block)
    return name unless SceneManager.scene_is?(Scene_Battle)
    states.sort {|a, b| b.priority <=> a.priority }.each {|a|
      if (add = Jet::VBS::STATE_SPRITES[a.id])
        return name + add[0]
      end
    }
    return name
  end

  alias jet3745_character_index character_index
  def character_index(*args, &block)
    index = jet3745_character_index(*args, &block)
    return index unless SceneManager.scene_is?(Scene_Battle)
    states.sort {|a, b| b.priority <=> a.priority }.each {|a|
      if (add = Jet::VBS::STATE_SPRITES[a.id])
        return index + add[1]
      end
    }
    return index
  end
end

class Sprite_Battler

  alias jet3835_update_bitmap update_bitmap
  def update_bitmap(*args, &block)

    jet3835_update_bitmap(*args, &block) if @battler.enemy?
    if @battler.actor? || @battler.bat_sprite?
      actor_update_bitmap
    end
  end

  def actor_update_bitmap
    @timer ||= 0
    @index ||= 1
    @char_index ||= @battler.character_index
    @back_time ||= false
    index = @index
    char_index = @char_index
    @timer += 1
    (@index += (@back_time ? -1 : 1); @timer = 0) if @timer == 19
    if @index == 3
      @back_time = true
      @index = 1
    elsif @index == -1
      @back_time = false
      @index = 1
    end
    @char_index = @battler.character_index

    if @battler.is_a?(Game_Summon)
      self.bitmap = Cache.battler(@battler.battler_name, 0)
      return
    else
      bitmap = Cache.character(@battler.character_name)
    end

    return if bitmap == @bitmap && index == @index && @char_index == char_index
    self.bitmap = bitmap
    sign = @battler.character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    dir = BattleManager.player_dir
    dir = 10 - dir if @battler.is_a?(Game_Enemy)
    sx = (@battler.character_index % 4 * 3) * cw + (cw * @index)
    sy = (@battler.character_index / 4 * 4 + (dir - 2) / 2) * ch
    self.src_rect.set(sx, sy, cw, ch)
  end

  alias jet3745_update_origin update_origin
  def update_origin(*args, &block)

    jet3745_update_origin(*args, &block) if @battler.enemy?
    if @battler.actor? || @battler.bat_sprite?
      actor_update_origin
    end
  end

  def actor_update_origin
    self.ox = (@actor_ox ||= 0)
    self.oy = (@actor_oy ||= 0)
  end

  def revert_to_normal
    self.blend_type = 0
    self.color.set(0, 0, 0, 0)
    self.opacity = 255
    if bitmap && @battler && !@battler.actor? && !@battler.bat_sprite?
      self.ox = bitmap.width / 2 if bitmap
      self.src_rect.y = 0
    end
  end

  def slide_forward(amount = Jet::VBS::SLIDE_AMOUNT, frame = Jet::VBS::FRAME_SLIDE)
    dir = BattleManager.player_dir
    dir = 10 - dir if @battler.is_a?(Game_Enemy)
    case dir
    when 2
      affect = :@actor_oy
      frame *= -1
    when 4
      affect = :@actor_ox
      amount *= -1
    when 6
      affect = :@actor_ox
      frame *= -1
    when 8
      affect = :@actor_oy
      amount *= -1
    end
    orig_amount = amount
    until (orig_amount < 0 ? amount >= 0 : amount <= 0)
      instance_variable_set(affect, instance_variable_get(affect) + frame)
      amount += frame
      SceneManager.scene.spriteset.update
      Graphics.update
    end
  end

  def slide_backward(amount = Jet::VBS::SLIDE_AMOUNT, frame = Jet::VBS::FRAME_SLIDE)
    dir = BattleManager.player_dir
    dir = 10 - dir if @battler.is_a?(Game_Enemy)
    case dir
    when 2
      affect = :@actor_oy
      amount *= -1
    when 4
      affect = :@actor_ox
      frame *= -1
    when 6
      affect = :@actor_ox
      amount *= -1
    when 8
      affect = :@actor_oy
      frame *= -1
    end
    orig_amount = amount
    until (orig_amount < 0 ? amount >= 0 : amount <= 0)
      instance_variable_set(affect, instance_variable_get(affect) + frame)
      amount += frame
      SceneManager.scene.spriteset.update
      Graphics.update
    end
  end
end

class Scene_Battle

  attr_reader :spriteset

  def show_attack_animation(targets)
    show_normal_animation(targets, @subject.atk_animation_id1, false)
    show_normal_animation(targets, @subject.atk_animation_id2, true)
  end

  alias jet3746_use_item use_item
  def use_item(*args, &block)
    sprite = @spriteset.battler_to_sprite(@subject)
    if (@subject.actor? || @subject.bat_sprite?) && !@subject.current_action.guard?
      sprite.slide_forward
    end
    jet3746_use_item(*args, &block)
    if (@subject.actor? || @subject.bat_sprite?) && !@subject.current_action.guard?
      sprite.slide_backward
    end
  end
end

class Spriteset_Battle

  def battler_to_sprite(actor)
    battler_sprites.each {|a|
      return a if a.battler == actor
    }
    return false
  end
end

class Window_BattleEnemy

  alias jet3745_update update
  def update(*args, &block)
    jet3745_update(*args, &block)
    if self.active && Jet::VBS::DO_FLASH
      if Object.const_defined?(:Mouse)
        $game_troop.alive_members.each {|a|
          img = SceneManager.scene.spriteset.battler_to_sprite(a)
          x = img.x - img.ox
          y = img.y - img.oy
          if Mouse.area?(x, y, img.src_rect.width, img.src_rect.height)
            self.index = a.index
          end
        }
      end
      active_troop = $game_troop.alive_members[@index]
      sprite = SceneManager.scene.spriteset.battler_to_sprite(active_troop)
      sprite.start_effect(:whiten) if !sprite.effect?
    end
  end
end

class Window_BattleActor

  alias jet3745_update update
  def update(*args, &block)
    jet3745_update(*args, &block)
    if self.active && Jet::VBS::DO_FLASH
      if Object.const_defined?(:Mouse)
        $game_party.alive_members.each {|a|
          img = SceneManager.scene.spriteset.battler_to_sprite(a)
          x = img.x - img.ox
          y = img.y - img.oy
          if Mouse.area?(x, y, img.src_rect.width, img.src_rect.height)
            self.index = a.index
          end
        }
      end
      active_troop = $game_party.members[@index]
      sprite = SceneManager.scene.spriteset.battler_to_sprite(active_troop)
      sprite.start_effect(:whiten) if !sprite.effect?
    end
  end
end

class Window_ActorCommand

  alias jet3745_update update
  def update(*args, &block)
    jet3745_update(*args, &block)
    if self.active && Jet::VBS::DO_FLASH
      active_troop = @actor
      sprite = SceneManager.scene.spriteset.battler_to_sprite(active_troop)
      sprite.start_effect(:whiten) if !sprite.effect?
    end
  end
end

class Game_Action
  def guard?
    item == $data_skills[subject.guard_skill_id] || item.note.match(/<summon>/)
  end
end