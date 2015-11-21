class Window_SelectableArrow < Window_Base
  attr_reader   :index                    # Posição do Cursor

  def initialize(x, y, width, height, arrow_right, arrow_left, options)
    super(x, y, width, height)

    @arrow_right = arrow_right
    @arrow_left  = arrow_left
    @options     = options
    @index       = 0
  end

  def index=(index)
    @index = index
    update_arrow
  end

  def update
    super
  end

  def update_arrow
    return unless self.active

    select_arrow(:right) if Input.trigger?(Input::RIGHT)
    select_arrow(:left)  if Input.trigger?(Input::LEFT)
  end

  def select_arrow(side)
    side == :right ? increment_index : decrement_index
    print @index
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