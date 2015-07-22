require_relative '08_session'
require_relative '09_params'
require_relative '12_flash'
require 'erb'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'json'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Already rendered!" if already_built_response?
    @already_built_response = true
    res.header["location"] = url
    res.status = 302
    reset_flash
    session.store_session(res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    template = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    render_content(ERB.new(template).result(binding), "text/html")
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "Already rendered!" if already_built_response?
    @already_built_response = true
    res.body = content
    res.content_type = content_type
    reset_flash
    session.store_session(res)
  end

  def reset_flash
    session["flash_now"] = {}
    flash.flash_hash.each do |key, value|
      session["flash_now"][key] = value
    end
    session.delete("flash")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(session)
  end

  def invoke_action(name)
    self.send(name)
    render_content(name, "text/html") unless already_built_response?
  end
end
