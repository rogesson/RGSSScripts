class FieldSlot < FieldBase
  def initialize(x, y)
    super(x, y)
    @type = :field_slot
  end
end