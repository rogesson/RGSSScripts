class Image_Cache
  def initialize
    @images = []
  end

  def find_bitmap(image_name)
    image = find_image(image_name)

    if image
      image.fetch(:bitmap)
    else
      bitmap = create_bitmap(image_name)
      @images << { name: image_name, bitmap: bitmap }
      bitmap
    end
  end

  private

  def find_image(image_name)
     @images.detect { |image|  image[:name] == image_name }
  end

  def create_bitmap(image_name)
    Cache.system(image_name)
  end
end