class Player_HP_Test < RTest::Test
  before do
    subject { Player_HP.new(300) }
    subject.screen_x = 20
    subject.screen_y = 10
  end

  describe '#max_hp' do
    it "Deve ter 300 de HP Máximo" do
      assert_equal 300, subject.max_hp
    end
  end

  describe '#current_hp' do
    it "Deve ter 300 de HP" do
      assert_equal 300, subject.current_hp
    end
  end

  describe '#update_position' do
    it 'Deve ter a mesma posicao' do
      subject.send(:update_position)
      assert subject.send(:same_position?)
    end
  end

  # TODO Criar um 'contexto'
  describe '#update_position' do
    it 'deve ter posicao diferente' do
      subject.screen_y = 15
      assert !subject.send(:same_position?)
    end
  end

  describe '#create_sprite' do
    it 'deve criar o bitmap e o sprite do HP' do
      subject.send(:create_sprite)

      assert subject.instance_variable_get('@sprite').is_a?(Sprite)
      assert subject.instance_variable_get('@sprite').bitmap.is_a?(Bitmap)
    end
  end
end