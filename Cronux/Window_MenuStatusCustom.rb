

class Window_MenuStatusCustom < Window_Selectable
  def initialize
    super(250, 0, 428, 480)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.contents.font.size = $fontsize
    self.opacity = 230

    create_arrows
    create_character_box
    create_face_list

    refresh
    self.active = false
    self.index = -1
  end

  def refresh
    self.contents.clear
    @item_max = $game_party.actors.size

      i = 3
      x = 0
      y = i * 116
      actor = $game_party.actors[i]
      #draw_actor_graphic(actor, x - 40, y + 80)
      draw_actor_name(actor, x, y)
      draw_actor_class(actor, x + 144, y)
      draw_actor_level(actor, x, y + 32)
      draw_actor_state(actor, x + 90, y + 32)
      draw_actor_exp(actor, x, y + 64)
      draw_actor_hp(actor, x + 236, y + 32)
      draw_actor_sp(actor, x + 236, y + 64)
   


    for i in 0...$game_party.actors.size
      return 
      x = 64
      y = i * 116
      actor = $game_party.actors[i]
      draw_actor_graphic(actor, x - 40, y + 80)
      draw_actor_name(actor, x, y)
      draw_actor_class(actor, x + 144, y)
      draw_actor_level(actor, x, y + 32)
      draw_actor_state(actor, x + 90, y + 32)
      draw_actor_exp(actor, x, y + 64)
      draw_actor_hp(actor, x + 236, y + 32)
      draw_actor_sp(actor, x + 236, y + 64)
    end
  end

  def create_arrows
    create_arrow_left
    create_arrow_right
  end

  def create_arrow_left
    @arrow_left = Sprite.new
    @arrow_left.bitmap = Bitmap.new("Graphics/Pictures/arrow_left")

    @arrow_left.x = 270 
    @arrow_left.y = 125
    @arrow_left.z = 101

    @arrow_left.opacity = 50
  end
  
  def create_arrow_right
    @arrow_left = Sprite.new
    @arrow_left.bitmap = Bitmap.new("Graphics/Pictures/arrow_right")

    @arrow_left.x = 525
    @arrow_left.y = 125
    @arrow_left.z = 101

    @arrow_left.opacity = 150
  end

  def create_character_box
    x = 393
    1.times do
      Character_InfoWindow.new(x)
      x += 135
    end
  end

  def create_face_list
    face = Sprite.new
    face.bitmap = Bitmap.new("Graphics/Pictures/face_character1")

    face.x = 525
    face.y = 20
    face.z = 101

    face2 = Sprite.new
    face2.bitmap = Bitmap.new("Graphics/Pictures/male_head")

    face2.x = 564
    face2.y = 20
    face2.z = 101
  end
end

class Character_InfoWindow < Window_Base
  def initialize(x)
    super(x, 70, 100, 340)
    self.opacity = 0
    @x = x
    @y = 17

    create_overlay
    create_background
  end

  def create_overlay
    background_sprite = Sprite.new
    background_sprite.bitmap = Bitmap.new("Graphics/Pictures/overlay")
    background_sprite.opacity = 200
    
    background_sprite.x = @x
    background_sprite.y = @y
    background_sprite.z = 102
  end

  def create_background
    background_sprite = Sprite.new

    background_sprite.bitmap = Bitmap.new("Graphics/Pictures/character_01")
    background_sprite.x = @x + 6
    background_sprite.y = @y + 6
    background_sprite.z = 101
  end
end

