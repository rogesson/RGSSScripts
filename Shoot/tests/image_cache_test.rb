class Image_Cache_Test < RTest::Test
  before do
    subject { Image_Cache.new }
  end

  describe '#initialize' do
    it 'deve criar um Array vazio' do
      images = subject.instance_variable_get('@images')
      assert_equal [], images
    end
  end

  describe '#find_bitmap' do
    it 'deve adicionar a imagem no Array de imagens' do
      allow(subject).to_receive(:create_bitmap, :image_name) { Bitmap }

      subject.find_bitmap('some_image')

      images = subject.instance_variable_get('@images')

      assert !images.empty?
      assert_equal 'some_image', images.first[:name]
    end

    it 'deve usar a imagem que está no Array' do
      subject.find_bitmap('some_image')

      images = subject.instance_variable_get('@images')

      assert !images.empty?
      assert_equal 1, images.size
      assert_equal 'some_image', images.first[:name]
    end
  end
end