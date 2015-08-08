#=============================================================================
  # Desenha o hp
  #=============================================================================
  def draw_hp
    @hp.bitmap.clear
    @hp.bitmap = Bitmap.new(@hpw,@hph)
    hpw = @hpw * @actor.hp / @actor.mhp
    hph = @hph
    rect = Rect.new(0,0,hpw,hph)
    @hp.bitmap.blt(0,0,Cache.system(HUD_Config::HP_IMG),rect)
  end
  #=============================================================================
  # Desenha o mp
  #=============================================================================
  def draw_mp
    @mp.bitmap.clear
    @mp.bitmap = Bitmap.new(@mpw,@mph)
    mpw = @mpw * @actor.mp / @actor.mmp
    mph = @mph
    rect = Rect.new(0,0,mpw,mph)
    @mp.bitmap.blt(0,0,Cache.system(HUD_Config::MP_IMG),rect)
  end

Para terminar, agora coloque o método draw_hp no update, mas não coloque ele sozinho, coloque-o junto de uma condição, draw_hp if hp_need_update?, esse foi o método que criamos para verificar se a hud precisa atualizar, ou só o hp, agora com o draw_mp faça a mesma coisa, só que é claro que na condição coloque mp_need_update?

Bem agora terminamos tudo, pode testar que provavelmente vai estar funcionando, se não estiver, passe seu código e eu vejo o que pode estar de errado! Na próxima aula, vou mostrar alguns efeitos que podemos fazer para que a hud fique mais flexível!

Até mais, espero que tenham gostado da aula, e antes que eu me esqueça, aqui o código completo:

#===============================================================================
# Criand uma HUD
# CRM
#===============================================================================
module HUD_Config
  #=============================================================================
  # Configurações
  #=============================================================================
  Clear_Speed = 5 # Velocidade com que a hud desaparece ao herói se aproximar #
  HP_IMG = "HP" # Imagem do HP na pasta system #
  HP_XY = [0,0] # Posição X e Y do hp #
  MP_IMG = "MP" # Imagem do MP na pasta system #
  MP_XY = [0,30] # Posição X e Y do mp #
  #=============================================================================
  # Fim das configurações
  #=============================================================================
end
#===============================================================================
# Classe Scene_Map modificada para mostrar a HUD
#===============================================================================
class Scene_Map < Scene_Base
  alias gst_hud_start start
  alias gst_update update
  alias gst_hud_terminate terminate
  #=============================================================================
  # Metodo que inicia a classe
  #=============================================================================
  def start
    @actor = $game_party.members[0]
    gst_hud_start
    create_hud
    update_variables
  end
  #=============================================================================
  # Metodo que atualiza a classe
  #=============================================================================
  def update
    gst_update
    draw_hp if hp_need_update?
    draw_mp if mp_need_update?
  end
  #=============================================================================
  # Metodo que termina a classe
  #=============================================================================
  def terminate
    gst_hud_terminate
    dispose_hud
  end
  #=============================================================================
  # Metodo que cria todo conteúdo da hud
  #=============================================================================
  def create_hud
    create_sprites
    create_bitmaps
    get_bitmap_size
    draw_hp
    draw_mp
  end
  #=============================================================================
  # Metodo que apaga todo conteúdo da hud
  #=============================================================================
  def dispose_hud
    @hp.bitmap.dispose
    @hp.dispose
    @mp.bitmap.dispose
    @mp.dispose
  end
  #=============================================================================
  # Cria os sprites
  #=============================================================================
  def create_sprites
    @hp = Sprite.new
    @mp = Sprite.new
  end
  #=============================================================================
  # Cria os bitmaps
  #=============================================================================
  def create_bitmaps
    @hp.bitmap = Bitmap.new("Graphics/System/#{HUD_Config::HP_IMG}")
    @mp.bitmap = Bitmap.new("Graphics/System/#{HUD_Config::MP_IMG}")
    @hp.x = HUD_Config::HP_XY[0]
    @hp.y = HUD_Config::HP_XY[1]
    @mp.x = HUD_Config::MP_XY[0]
    @mp.y = HUD_Config::MP_XY[1]
  end
  #=============================================================================
  # Atualiza as variáveis HP e MP
  #=============================================================================
  def update_variables
    @actor_hp = @actor.hp
    @actor_mhp = @actor.mhp
    @actor_mp = @actor.mp
    @actor_mmp = @actor.mmp
  end
  #=============================================================================
  # Pega o tamanho dos bitmaps
  #=============================================================================
  def get_bitmap_size
    @hpw = @hp.width
    @hph = @hp.height
    @mpw = @mp.width
    @mph = @mp.height
  end
  #=============================================================================
  # Verifica se o hp precisa atualizar
  #=============================================================================
  def hp_need_update?
    return true unless @actor_hp == @actor.hp
    return true unless @actor_mhp == @actor.mhp
  end
  #=============================================================================
  # Verifica se o mp precisa atualizar
  #=============================================================================
  def mp_need_update?
    return true unless @actor_mp == @actor.mp
    return true unless @actor_mmp == @actor.mmp
  end
  #=============================================================================
  # Desenha o hp
  #=============================================================================
  def draw_hp
    @hp.bitmap.clear
    @hp.bitmap = Bitmap.new(@hpw,@hph)
    hpw = @hpw * @actor.hp / @actor.mhp
    hph = @hph
    rect = Rect.new(0,0,hpw,hph)
    @hp.bitmap.blt(0,0,Cache.system(HUD_Config::HP_IMG),rect)
  end
  #=============================================================================
  # Desenha o mp
  #=============================================================================
  def draw_mp
    @mp.bitmap.clear
    @mp.bitmap = Bitmap.new(@mpw,@mph)
    mpw = @mpw * @actor.mp / @actor.mmp
    mph = @mph
    rect = Rect.new(0,0,mpw,mph)
    @mp.bitmap.blt(0,0,Cache.system(HUD_Config::MP_IMG),rect)
  end
end