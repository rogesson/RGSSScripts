class AnimateTest < RTest::Test
  before do
    resource      = nil
    image_name    = 'explosion'
    sprite        = Sprite.new
    sprite.x      = 1
    sprite.y      = 1
    sprite.bitmap = Bitmap.new(32, 32)
    images_count  = 5
    repeat        = false
    chain         = false

    subject { Animate.new(sprite, image_name, images_count, repeat, chain) }
  end

  describe '#execute' do
    it 'deve atualizar o frame' do
      frames = subject.instance_variable_get('@frames')

      subject.execute
      assert subject.instance_variable_get('@frames') > frames
    end
  end

  describe '#update_frames' do
    it 'deve atualizar o frame' do
      frames = subject.instance_variable_get('@frames')

      subject.send(:update_frames)
      assert subject.instance_variable_get('@frames') > frames
    end
  end

  #describe '#update' do
  #  it 'deve atualizar a imagem' do
  #    subject.send(:update)
  #  end
  #end
end