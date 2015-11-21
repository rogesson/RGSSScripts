class Window_SelectableArrow < Window_Base
  attr_reader   :index

  def initialize(x, y, width, height, arrow_right, arrow_left, options)
    super(x, y, width, height)

    @arrow_right = arrow_right
    @arrow_left  = arrow_left
    @options     = options
    @index       = 0

    @arrow_max_opacity = true
  end

  def index=(index)
    @index = index
    update_arrow
  end

  def update
    super

    return unless self.active
    refresh_arrow
    update_arrow
  end

  def arrow_index
    @index
  end

  def refresh_arrow
    if @arrow_max_opacity
      @arrow_right.opacity -= 5
      @arrow_left.opacity -= 5
      @arrow_max_opacity = false if @arrow_right.opacity == 70
      @arrow_max_opacity = false if @arrow_left.opacity == 70
    else
      @arrow_right.opacity += 5
      @arrow_left.opacity += 5

      @arrow_max_opacity = true if @arrow_right.opacity == 255
      @arrow_max_opacity = true if @arrow_left.opacity == 255
    end
  end

  def update_arrow
    select_arrow(:right) if Input.trigger?(Input::RIGHT)
    select_arrow(:left)  if Input.trigger?(Input::LEFT)

  end

  def select_arrow(side)
    side == :right ? increment_index : decrement_index
  end

  def increment_index
    if @index < @options.length - 1
      @index += 1
    else 
      @index = 0
    end
  end

  def decrement_index
    if @index < 1
      @index = @options.length - 1
    else
      @index -= 1
    end
  end
end