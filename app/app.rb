require 'erb'
require 'pry'
require_relative 'helpers/image_helper.rb'

class App
  def call(env)
    req = Rack::Request.new(env)
    req_path = req.path_info
    path = req_path.delete('/').gsub('-', '_')

    if path.empty?
      render('home')
    elsif path.include?('images')
      ImageHelper.serve_image(req_path)
    else
      render(path)
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

    handle_missing_path unless template

    erb = ERB.new(template)
    erb.result(binding)
  end

  def handle_missing_path
    body = File.read("./public/404.html")
    headers = { 'Content-Type' => 'text/html; charset=utf-8' }

    [404, headers, [body]]
  end
end