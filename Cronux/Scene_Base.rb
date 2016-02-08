class Scene_Base

  attr_accessor :current_window

  def set_current_window(new_window)
    # Deactivate old window.
    @current_window.active = false if @current_window
    
    # Set new window and active it.
    @current_window = new_window
    @current_window.active = true
  end

  def listen_event
    on_confirm  if Input.trigger?(Input::C)
    on_cancel   if Input.trigger?(Input::B)
  end

  def on_confirm
    @current_window.confirm
  end

  def on_cancel
    @current_window.cancel
  end
end