class ImageHelper
  def self.serve_image(img_path)
    image_path = "app/public#{img_path}"

    if File.exist?(image_path)
      image = File.read(image_path)
      [200, { 'Content-Type' => 'image/jpeg' }, [image]]
    else
      [404, { 'Content-Type' => 'text/plain' }, ['Image not found']]
    end
  end
end