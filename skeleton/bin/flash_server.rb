require 'webrick'
require_relative '../lib/06_controller_base'


class MyController < ControllerBase
  def go
    session["count"] ||= 0
    session["count"] += 1
    flash["#{session["count"]}"] = "Flash: #{session["count"]}."
    flash.now["#{session["count"]}"] = "Flash.now: #{session["count"]}."
    render :counting_show
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  MyController.new(req, res).go
end

trap('INT') { server.shutdown }
server.start
