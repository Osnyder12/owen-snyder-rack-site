require 'erb'
require 'pry'

class App
  def call(env)
    req = Rack::Request.new(env)
    path = req.path_info

    if path == '/'
      render('home')
    elsif path.include?('/images')
      serve_image(path)
    else
      handle_missing_path
    end
  end

  private

  def render(template, status_code: 200)
    @content = render_template(template)
    body = render_template('layout')
    headers = { 'Content-Type' => 'text/html; charset=utf-8' }

    [status_code, headers, [body]]
  end

  def render_template(template)
    template = File.read("./app/views/#{template}.html.erb")
    erb = ERB.new(template)
    erb.result(binding)
  end

  def handle_missing_path
    body = File.read("./public/404.html")
    headers = { 'Content-Type' => 'text/html; charset=utf-8' }

    [404, headers, [body]]
  end

  def serve_image(img_path)
    image_path = "app/public#{img_path}"

    if File.exist?(image_path)
      image = File.read(image_path)
      [200, { 'Content-Type' => 'image/jpeg' }, [image]]
    else
      [404, { 'Content-Type' => 'text/plain' }, ['Image not found']]
    end
  end
end