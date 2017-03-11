class Image_Cache_Test < RTeste::Teste
  antes do
    sujeito { Image_Cache.new }
  end

  descrever '#initialize' do
    isso 'deve criar um Array vazio' do
      images = sujeito.instance_variable_get('@images')
      afirmar_igualdade [], images
    end
  end

  descrever '#find_bitmap' do
    isso 'deve adicionar a imagem no Array de imagens' do
      allow(sujeito).to_receive(:create_bitmap, :image_name) { Bitmap }

      sujeito.find_bitmap('some_image')

      images = sujeito.instance_variable_get('@images')

      nao_afirmar images.empty?
      afirmar_igualdade 'some_image', images.first[:name]
    end
  end
end